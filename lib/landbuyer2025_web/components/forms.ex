defmodule Landbuyer2025Web.Forms do
  use Phoenix.Component

  attr :type, :string, default: "text"
  attr :value, :string, default: ""
  attr :error, :string, default: nil
  attr :name, :string, required: true
  attr :placeholder, :string, default: ""
  attr :disabled, :boolean, default: false
  attr :class, :string, default: ""

  def text_input(assigns) do
    border_class =
      if assigns.error do
        "border-red"
      else
        "border-slate-700"
      end

    assigns = assign(assigns, :border_class, border_class)

    ~H"""
    <div>
      <input
        type={@type}
        name={@name}
        value={@value}
        placeholder={@placeholder}
        disabled={@disabled}
        class={[
          "w-full h-8 p-2 rounded bg-slate-200 text-slate-700 border",
          @border_class,
          "text-sm placeholder:italic placeholder-slate-400 placeholder:text-xs",
          @class
        ]}
      />
      <div class="text-red text-xs">
        {if @error, do: @error, else: ""}
      </div>
    </div>
    """
  end
end
