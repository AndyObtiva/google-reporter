def input(name, bind_attr, **args)
  multi = args[:multi] || false
  search = args[:search] || false
  bind_opts = {}.tap do |hash|
    hash[:on_read] = args[:on_read] if args.key?(:on_read)
    hash[:on_write] = args[:on_write] if args.key?(:on_write)
  end

  group {
    layout_data :fill, :beginning, true, false
    grid_layout(1, true) {
      margin_top 0
      margin_bottom 8
      margin_height 0
      margin_width 12
    }
    label {
      font style: :bold
      text name.upcase
    }
    text((:wrap if multi), (:search if search)) { |proxy|
      font name: "Helvetica", height: 12
      layout_data(:fill, :beginning, true, true) {
        heightHint 3 * proxy.get_line_height if multi
      }
      text bind(@state, bind_attr, **bind_opts)
      on_verify_text { |ev|
        ev.text = " " if /[\n\t\r]/.match?(ev.character.chr)
      }
    }
  }
end
