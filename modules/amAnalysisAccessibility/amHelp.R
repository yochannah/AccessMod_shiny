



# help panels. NOTE: should be written in external file / db ?...

observeEvent(input$helpLinkSpeedTable,{
  content <- tagList(
    tags$p("You can edit the content of the \"travel scenario to be processed\" table (\"label\", \"speed\" and \"mode\" columns) by:"),
    tags$ol(
      tags$li("importing the content from the external scenario table;"),
      tags$li("Directlty editing the text in the table;"),
      tags$li("Copying and pasting text from an external spreadsheet.")
      ),
    tags$p("Clicking on \"reset\" will bring back the original content of the table.")
    )


  amUpdateModal(panelId='amHelpPanel',title=config$helpTitle,html=content)

})