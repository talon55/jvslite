require 'compass'
require 'sinatra'
require 'haml'


configure do
  set :haml, {format: :html5, escape_html: false}
  set :scss, {style: :compact, debug_info: false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

get '/stylesheets/:name.css' do
  content_type 'text/css', charset: 'utf-8'
  scss(:"stylesheets/#{params[:name]}" )
end

# page definitions

get '/' do
  haml :index
end

get '/:page' do
  @page = params[:page]
  @links = { preview: "JOHNNY'S FAVORITES",
            life_story: "LIFESTORY",
            pro_baseball: "PRO BASEBALL"
            }.delete_if {|key, value| key == @page.to_sym}
  
  begin
    haml params[:page].to_sym 
  rescue Errno::ENOENT
    not_found
  end
end

not_found {haml :'404', layout: false} # graceful 404s

#get '/preview' do #replace these with :page
#  haml :preview, locals: {page: "preview"}
#end

#get '/lifestory' do
#  haml :lifestory, locals: {page: "lifestory"}
#end

#get '/pro_baseball' do
#  haml :pro_baseball, locals: {page: "pro_baseball"}
#end

#helper methods

helpers do
  def image_tag name, options=nil # refactor with args hash
    page = caller[0][/\/(?:.(?!\/))+$/][/.*\./][1..-2]
    # This ugly regex hack isolates the filename from which this method was called
    # I'm sure it could be reduced to a single regex if I had any experience writing them
    
    # The point of this is to programmatically determine whether the caller is 
    # the layout since it's the only place that doesn't rely on an @page variable
    
    #puts page + " " + name
    if page == "layout"
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/#{name}\" #{options}>"
    else
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/gallery/#{@page}/#{name}\" #{options}>"
    end
  end

  def partial page, options={}
    haml page.to_sym, options.merge!(layout: false)
  end
  
  def frame_tag side, title, image, description
    haml :_frame, {locals: {side: side, title: title, image: image, description: description}, layout: false}
  end
end
