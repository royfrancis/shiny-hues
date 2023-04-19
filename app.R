## shiny-hues
## R shinyapp to generate distinct colours
## 2023 Roy Francis

library(shiny)
library(hues)
library(bslib)

## version
fn_version <- function() {
  return("v1.0.0")
}

shinyApp(
  ui = page_fixed(
    class = "app-container",
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
    title = "Hues",
    theme = bs_theme(bootswatch = "minty"),
    card(
      card_header(
        class = "app-header",
        HTML("<h3><b>Hues</b>: Colour Generator</h3>"),
      ),
      layout_sidebar(
        sidebar(
          numericInput("in_n", "Number of colours", value = 15),
          sliderInput("in_hue", "Hue", min = 0, max = 360, value = c(0, 360)),
          sliderInput("in_chr", "Chroma", min = 0, max = 180, value = c(0, 180)),
          sliderInput("in_lig", "Lightness", min = 0, max = 100, value = c(0, 100)),
        ),
        htmlOutput("out_display"),
        hr(),
        textOutput("out_text")
      ),
      card_footer(
        class = "app-footer",
        div(
          class = "app-footer-child",
          "Built on ", a("hues", href = "https://github.com/johnbaums/hues"), " Version ", a(fn_version(), href = "https://github.com/royfrancis/shiny-hues")
        )
      )
    )
  ),
  server = function(input, output) {
    get_colours <- reactive({
      hues::iwanthue(
        n = input$in_n,
        hmin = min(input$in_hue),
        hmax = max(input$in_hue),
        cmin = min(input$in_chr),
        cmax = max(input$in_chr),
        lmin = min(input$in_lig),
        lmax = max(input$in_lig)
      )
    })

    output$out_display <- renderText({
      cols <- get_colours()
      paste("<div class='grid-parent'>", paste("<span class='grid-child' style='background-color:", cols, ";'>  </span>", collapse = ""), "</div>", sep = "", collapse = "")
    })

    output$out_text <- renderText({
      cols <- get_colours()
      paste(cols, collapse = ", ")
    })
  }
)
