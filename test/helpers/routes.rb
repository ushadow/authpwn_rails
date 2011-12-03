# :nodoc: the routes used in all tests
class ActionController::TestCase
  def setup_routes
    @routes = ActionController::Routing::RouteSet.new
    @routes.draw do
      resource :cookie, :controller => 'cookie' do
        collection { get :bouncer }
      end
      resource :facebook, :controller => 'facebook'
      authpwn_session :controller => 'bare_session',
                      :method_names => 'bare_session'
      root :to => 'session#index'

      # NOTE: this route should be kept in sync with the session template.
      authpwn_session
    end
    ApplicationController.send :include, @routes.url_helpers
  end
  
  setup :setup_routes
end
