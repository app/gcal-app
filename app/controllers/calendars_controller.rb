
class CalendarsController < ApplicationController
  def show
    client = Signet::OAuth2::Client.new({
      # Development server credentials
      client_id: 'Put id here',
      client_secret: 'Put secret here',

      # production server credentials
      #client_id: 'Put clients id here',
      #client_secret: 'Put secret here',

      #client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      #client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: url_for(:action => :callback)
    })

    redirect_to client.authorization_uri.to_s
    
  end

  def list
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    begin
	@calendar_list = service.list_calendar_lists
    rescue
	redirect_to url_for(:action => :show)
    end

  end

  def callback
    client = Signet::OAuth2::Client.new({
      # Development server credentials
      client_id: 'Put id here',
      client_secret: 'Put secret here',

      # production server credentials
      #client_id: 'Put clients id here',
      #client_secret: 'Put secret here',

      #client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      #client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :callback),
      code: params[:code]
    })

    response = client.fetch_access_token!
    session[:access_token] = response['access_token']
    redirect_to url_for(:action => :list)
  end

  def signout
    uri = URI('https://accounts.google.com/o/oauth2/revoke')
    params = { :token => session[:access_token]}
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    redirect_to url_for(:action => :list)

  end

end
