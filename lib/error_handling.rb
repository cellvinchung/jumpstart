# frozen_string_literal: true

def setup_error_handling
  after_bundle do
    generate 'controller errors'
    inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController' do
      <<~RUBY
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

        def record_not_found
          render template: "errors/not_found", status: :not_found
          #TODO: set error page, demo at jumpstart/errors
        end
      RUBY
    end

    inject_into_class 'app/controllers/errors_controller.rb', 'ErrorsController' do
      <<~RUBY
        def not_found
          respond_to do |format|
            format.html { render status: :not_found }
            format.json { render json: { error: t('not_found') }, status: :not_found }
          end
        end

        def unacceptable
          respond_to do |format|
            format.html { render status: :unprocessable_entity, layout: false }
            format.json { render json: { error: t('not_found') }, status: :unprocessable_entity }
          end
        end

        def internal_error
          respond_to do |format|
            format.html { render status: :internal_server_error, layout: false }
            format.json { render json: { error: t('internal_server_error') }, status: :internal_server_error }
          end
        end

        def timeout
          respond_to do |format|
            format.html { render status: :service_unavailable, layout: false }
            format.json { render json: { error: t('service_unavailable') }, status: :service_unavailable }
          end
        end
      RUBY
    end

    file 'app/views/errors/internal_error.html.erb' do
      <<~ERB
        <!DOCTYPE html>
        <html>
        <head>
          <title>網站發生錯誤</title>
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <style>
          .rails-default-error-page {
            background-color: #EFEFEF;
            color: #2E2F30;
            text-align: center;
            font-family: arial, sans-serif;
            margin: 0;
          }

          .rails-default-error-page div.dialog {
            width: 95%;
            max-width: 33em;
            margin: 4em auto 0;
          }

          .rails-default-error-page div.dialog > div {
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #BBB;
            border-top: #B00100 solid 4px;
            border-top-left-radius: 9px;
            border-top-right-radius: 9px;
            background-color: white;
            padding: 7px 12% 0;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }

          .rails-default-error-page h1 {
            font-size: 100%;
            color: #730E15;
            line-height: 1.5em;
          }

          .rails-default-error-page div.dialog > p {
            margin: 0 0 1em;
            padding: 1em;
            background-color: #F7F7F7;
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #999;
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
            border-top-color: #DADADA;
            color: #666;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }
          </style>
        </head>

        <body class="rails-default-error-page">
          <div class="dialog">
            <div>
              <h1>很抱歉，網站發生錯誤</h1>
              <p>時間：<%= l(Time.current, format: :long)%></p>
              <p>網址：<%= request.original_url %></p>
              <p>瀏覽器：<%= browser.name%> <%= browser.full_version%><br>
                    裝置：<%= browser.device.name%><br>
                    平台：<%= browser.platform.name%></p>
            </div>
          </div>
        </body>
        </html>
      ERB
    end

    file 'app/views/errors/not_found.html.erb' do
      <<~ERB
        <!DOCTYPE html>
        <html>
        <head>
          <title>頁面不存在</title>
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <style>
          .rails-default-error-page {
            background-color: #EFEFEF;
            color: #2E2F30;
            text-align: center;
            font-family: arial, sans-serif;
            margin: 0;
          }

          .rails-default-error-page div.dialog {
            width: 95%;
            max-width: 33em;
            margin: 4em auto 0;
          }

          .rails-default-error-page div.dialog > div {
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #BBB;
            border-top: #B00100 solid 4px;
            border-top-left-radius: 9px;
            border-top-right-radius: 9px;
            background-color: white;
            padding: 7px 12% 0;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }

          .rails-default-error-page h1 {
            font-size: 100%;
            color: #730E15;
            line-height: 1.5em;
          }

          .rails-default-error-page div.dialog > p {
            margin: 0 0 1em;
            padding: 1em;
            background-color: #F7F7F7;
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #999;
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
            border-top-color: #DADADA;
            color: #666;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }
          </style>
        </head>

        <body class="rails-default-error-page">
          <div class="dialog">
            <div>
              <h1>頁面不存在</h1>
            </div>
          </div>
        </body>
        </html>
      ERB
    end

    file 'app/views/errors/timeout.html.erb' do
      <<~ERB
        <!DOCTYPE html>
        <html>
        <head>
          <title>連線逾時</title>
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <style>
          body {
            background-color: #EFEFEF;
            color: #2E2F30;
            text-align: center;
            font-family: arial, sans-serif;
            margin: 0;
          }

          div.dialog {
            width: 95%;
            max-width: 33em;
            margin: 4em auto 0;
          }

          div.dialog > div {
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #BBB;
            border-top: #B00100 solid 4px;
            border-top-left-radius: 9px;
            border-top-right-radius: 9px;
            background-color: white;
            padding: 7px 12% 0;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }

          h1 {
            font-size: 100%;
            color: #730E15;
            line-height: 1.5em;
          }

          div.dialog > p {
            margin: 0 0 1em;
            padding: 1em;
            background-color: #F7F7F7;
            border: 1px solid #CCC;
            border-right-color: #999;
            border-left-color: #999;
            border-bottom-color: #999;
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
            border-top-color: #DADADA;
            color: #666;
            box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
          }
          </style>
        </head>

        <body>
          <!-- This file lives in public/503.html -->
          <div class="dialog">
            <div>
              <h1>連線逾時</h1>
            </div>
            <p>請檢查網路連線狀況，並稍後再試一次。</p>
          </div>
        </body>
        </html>
      ERB
    end

    file 'app/views/errors/unacceptable.html.erb' do
      <<~ERB
      <!DOCTYPE html>
      <html>
      <head>
        <title>存取被拒</title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <style>
        .rails-default-error-page {
          background-color: #EFEFEF;
          color: #2E2F30;
          text-align: center;
          font-family: arial, sans-serif;
          margin: 0;
        }

        .rails-default-error-page div.dialog {
          width: 95%;
          max-width: 33em;
          margin: 4em auto 0;
        }

        .rails-default-error-page div.dialog > div {
          border: 1px solid #CCC;
          border-right-color: #999;
          border-left-color: #999;
          border-bottom-color: #BBB;
          border-top: #B00100 solid 4px;
          border-top-left-radius: 9px;
          border-top-right-radius: 9px;
          background-color: white;
          padding: 7px 12% 0;
          box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
        }

        .rails-default-error-page h1 {
          font-size: 100%;
          color: #730E15;
          line-height: 1.5em;
        }

        .rails-default-error-page div.dialog > p {
          margin: 0 0 1em;
          padding: 1em;
          background-color: #F7F7F7;
          border: 1px solid #CCC;
          border-right-color: #999;
          border-left-color: #999;
          border-bottom-color: #999;
          border-bottom-left-radius: 4px;
          border-bottom-right-radius: 4px;
          border-top-color: #DADADA;
          color: #666;
          box-shadow: 0 3px 8px rgba(50, 50, 50, 0.17);
        }
        </style>
      </head>

      <body class="rails-default-error-page">
        <!-- This file lives in public/422.html -->
        <div class="dialog">
          <div>
            <h1>存取被拒</h1>
          </div>
          <p>沒有權限存取相關資源。</p>
        </div>
      </body>
      </html>
      ERB
    end
  end
end
