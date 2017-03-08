# CuratorRegisterable

Support password based sign-in by comparing the password to a hashed password. It also provides a generator for creating a sign-in page.

This module assumes you're using [Database Authenticatable](https://github.com/curator-ex/curator_database_authenticatable). In the future it might work with a OAuth 2 only workflow, but that Curator module hasn't been written yet.

## Installation

  1. Add `curator_registerable` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:curator_registerable, "~> 0.1.0"}]
    end
    ```

  2. Run the install command

    ```elixir
    mix curator_registerable.install
    ```

  3. Update `web/models/user.ex`

    ```elixir
    defmodule Auth.User do

      def create_registration_changeset(user, params \\ %{}) do
        user
        |> changeset(params)
        |> password_changeset(params)
      end

      def update_registration_changeset(user, params \\ %{}) do
        user
        |> changeset(params)
      end

    end
    ```

  4. Update `web/router.ex`

    ```elixir
    scope "/", Auth do
      pipe_through [:browser]

      resources "/registrations", RegistrationController, only: [:new, :create]
      get "/registrations/edit", RegistrationController, :edit
      get "/registrations", RegistrationController, :show
      put "/registrations", RegistrationController, :update, as: nil
      patch "/registrations", RegistrationController, :update
      delete "/registrations", RegistrationController, :delete

      ...
    end
    ```

  5. Update `lib/<otp_app>/curator_hooks.ex`

    ```elixir
    def after_extension(conn, :registration, user) do
      conn
      |> put_flash(:info, "Account was successfully created.")
      # |> Send a confirmation email?
      # |> Do other bookkeeping?
      |> redirect(to: "/")
    end
    ```

  6. (Optionally) Add a link to `web/templates/session/new.html.eex'

    ```elixir
    <%= button "Sign Up", to: registration_path(@conn, :new), class: "btn btn-secondary navbar-btn", method: :get %>
    ```
