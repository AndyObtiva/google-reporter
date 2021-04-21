require_relative "../model/state"

class GoogleReporter
  class AppView
    include Glimmer::UI::CustomShell

    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320

    ## Use before_body block to pre-initialize variables to use in body
    before_body do
      Display.app_name = "Google Reporter"
      Display.app_version = VERSION

      @state = State.new
    end

    ## Use after_body block to setup observers for widgets in body
    # after_body {
    #
    # }

    require_relative "input"
    require_relative "save_dialog"

    ## Add widget content inside custom shell body
    # Top-most widget must be a shell or another custom shell
    body {
      shell(:no_resize) {
        text "Google Reporter"
        image File.join(APP_ROOT, "package", "windows", "Google Reporter.ico") if OS.windows?

        minimum_size 400, 400
        font name: "Inter", height: 14
        grid_layout(1, false) {
          margin_width 0
          margin_height 0
        }

        composite {
          layout_data :fill, :beginning, true, false

          input "websites", :sites

          input "pesquisa", :query, multi: true, search: true

          group {
            layout_data :fill, :fill, true, true
            text(:center, :wrap, :read_only) {
              layout_data :fill, :fill, true, true
              text bind(@state, :search_text, computed_by: [:sites, :query])
            }
          }

          composite {
            layout_data :fill, :beginning, true, false
            grid_layout(2, false) {
              margin_height 0
            }

            spinner {
              layout_data :beginning, :beginning, false, false
              selection bind(@state, :limit)
            }
            button {
              layout_data :fill, :beginning, true, false
              text bind(@state, :submit_label, computed_by: :limit)
              on_widget_selected {
                save_dialog
                @state.run_search
              }
            }
          }
        }

        label(:separator, :horizontal) {
          layout_data :fill, :beginning, true, false
        }

        composite {
          layout_data :fill, :beginning, true, false

          text(:multi, :read_only, :v_scroll, :h_scroll) { |proxy|
            layout_data(:fill, :fill, true, true)

            text bind(@state, :log_readout, computed_by: :logs)
          }
          progress_bar {
            layout_data :fill, :beginning, true, false

            minimum 0
            maximum bind(@state, :progress_max, computed_by: :limit)
            selection bind(@state, :progress)
          }
        }
      }
    }
  end
end
