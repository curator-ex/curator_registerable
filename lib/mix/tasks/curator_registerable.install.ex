defmodule Mix.Tasks.CuratorRegisterable.Install do
  use Mix.Task

  @shortdoc "Generates controller, model and views for an HTML based session"

  @moduledoc """
  Generates a Curator Registration Page.

      mix curator_registerable.install

  Optionally, you can provide a name for the users module

      mix curator_registerable.install User users

  The first argument is the module name followed by
  its plural name (used for schema).

  The generated files will contain:

    * a view in web/views
    * a controller in web/controllers
    * new resources in web/templates
    * test file for the generated controller
  """
  def run(args) do
    switches = []

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    attrs   = Mix.Phoenix.attrs(attrs)
    binding = Mix.Phoenix.inflect(singular)
    path    = binding[:path]
    route   = String.split(path, "/") |> Enum.drop(-1) |> Kernel.++([plural]) |> Enum.join("/")
    binding = binding ++ [plural: plural, route: route, attrs: attrs,
                          params: Mix.Phoenix.params(attrs),
                          template_singular: String.replace(binding[:singular], "_", " "),
                          template_plural: String.replace(plural, "_", " ")]

    Mix.Phoenix.check_module_name_availability!("RegistrationController")
    Mix.Phoenix.check_module_name_availability!("RegistrationView")

    Mix.Phoenix.copy_from paths(), "priv/templates/curator_registerable.install", "", binding, [
      {:eex, "controller.ex",       "web/controllers/registration_controller.ex"},
      {:eex, "edit.html.eex",        "web/templates/registration/edit.html.eex"},
      {:eex, "form.html.eex",        "web/templates/registration/form.html.eex"},
      {:eex, "new.html.eex",        "web/templates/registration/new.html.eex"},
      {:eex, "show.html.eex",        "web/templates/registration/show.html.eex"},
      {:eex, "view.ex",             "web/views/registration_view.ex"},
      {:eex, "controller_test.exs", "test/controllers/registration_controller_test.exs"},
    ]

    instructions = """

    Add the resource to your browser scope in web/router.ex:

        resources "/registrations", RegistrationController, only: [:new, :create]
        get "/registrations/edit", RegistrationController, :edit
        get "/registrations", RegistrationController, :show
        put "/registrations", RegistrationController, :update, as: nil
        patch "/registrations", RegistrationController, :update
        delete "/registrations", RegistrationController, :delete

    """

    Mix.shell.info instructions
  end

  defp validate_args!([_, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help()
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    ["User", "users"]
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise """
    mix curator_registerable.install expects both singular and plural names
    of the generated resource followed by any number of attributes:

        mix curator_registerable.install User users
    """
  end

  defp paths do
    [".", :curator_registerable]
  end
end
