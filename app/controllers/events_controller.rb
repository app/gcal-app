class EventsController < ApplicationController
  def list

    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    calendar_id = params[:calendar] 
    begin
      @events_list= service.list_events(calendar_id, max_results: 10, single_events: true, order_by: 'startTime', time_min: Time.now.iso8601)
    rescue
      redirect_to url_for(:controller => :calendars, :action => :show)
    end

  end
end
