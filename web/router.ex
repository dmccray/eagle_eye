defmodule EagleEye.Router do
  use EagleEye.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EagleEye do
    pipe_through :browser # Use the default browser stack
		
    get "/", PageController, :index
		resources "/candidates", CandidateController, only: [:index, :show, :new, :create] do
			resources "/orders", OrderController, only: [:show, :new, :create]
		end

		resources "/organizations", OrganizationController, only: [:index, :show, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", EagleEye do
  #   pipe_through :api
  # end
end
