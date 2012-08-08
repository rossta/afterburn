require 'sinatra/base'
require 'erb'
require "rack/csrf"
require 'afterburn'
require 'afterburn/version'

module Afterburn
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/server/views"
    set :public_folder, "#{dir}/server/public"
    set :static, true

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      def current_section
        url_path request.path_info.sub('/','').split('/')[0].downcase
      end

      def current_page
        url_path request.path_info.sub('/','')
      end

      def url_path(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end
      alias_method :u, :url_path

      def path_prefix
        request.env['SCRIPT_NAME']
      end

      def partial(template, local_vars = {})
        erb(template.to_sym, {:layout => false}, local_vars)
      end

      def afterburn
        Afterburn
      end

      def current_member
        Afterburn.current_member
      end

      def current_projects
        Afterburn.current_projects
      end

      def current_project
        @current_project || current_projects.first
      end

      def csrf_token
        Rack::Csrf.csrf_token(env)
      end

      def csrf_tag
        Rack::Csrf.csrf_tag(env)
      end

      def csrt_metatag
        Rack::Csrf.metatag(env)
      end
    end

    def show(page, options = {})
      response["Cache-Control"] = "max-age=0, private, must-revalidate"
      begin
        erb page.to_sym, options
      rescue Errno::ECONNREFUSED
        erb :error, {:layout => false}, :error => "Can't connect to Redis! (#{Resque.redis_id})"
      end
    end

    get "/" do
      if current_member
        show :overview
      else
        show :members
      end
    end

    post "/members" do
      member_attrs = params[:member]
      raise Afterburn::Member.find(member_attrs[:name])
    end

    get "/projects/:id/edit" do
      show :edit_project, locals: { project: Afterburn::Project.find(params[:id]) }
    end

    get "/projects/:id" do
      @current_project = Afterburn::Project.find(params[:id])
      show :project
    end

    post "/projects/:id" do
      Project.find(params[:id]).update_attributes(params[:project])
      redirect url_path("/")
    end

    put "/projects/:id" do
      Project.find(params[:id]).update_attributes(params[:project])
      redirect url_path("/")
    end

    put "/lists/:id" do
      list = Afterburn::List.find(params[:id])
      list.update_attributes(params[:list])
      list.to_json
    end
  end
end