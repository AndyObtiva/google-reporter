require_relative '../model/state'

class GoogleReporter
  class AppView
    include Glimmer::UI::CustomShell

    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    option :greeting, default: 'Hello, World!'

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body do
      Display.app_name    = 'Google Reporter'
      Display.app_version = VERSION

      @state = State.new
    end

    ## Use after_body block to setup observers for widgets in body
    #
    # after_body {
    #
    # }

    def input(name, bind_attr, multi = false)
      group {
        layout_data :fill, :beginning, true, false
        grid_layout(1, true) {
          margin_top 0
          margin_bottom 8
          margin_height 0
          margin_width 12
        }
        label {
          font name: 'Inter', height: 12, style: :bold
          text name.upcase
        }
        text((:multi if multi)) { |proxy|
          layout_data(:fill, :beginning, true, false) {
            heightHint 3 * proxy.get_line_height + 8 if multi
          }
          font name: 'Helvetica', height: 16
          text bind(@state, bind_attr)
        }
      }
    end

    ## Add widget content inside custom shell body
    # Top-most widget must be a shell or another custom shell
    body {
      shell(:no_resize) {
        text 'Google Reporter'
        image File.join(APP_ROOT, 'package', 'windows', 'Google Reporter.ico') if OS.windows?

        minimum_size 600, 400
        grid_layout(3, false) {
          margin_width 0
          margin_height 0
        }

        composite {
          layout_data :fill, :beginning, true, true
          input 'Websites', :sites
          input 'Pesquisa', :query, true
        }

        label(:separator) {
          layout_data :center, :fill, false, true
        }

        composite {
          layout_data :fill, :beginning, true, true
        }
      }
    }
  end
end
