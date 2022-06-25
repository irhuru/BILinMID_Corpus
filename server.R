library(dplyr)
library(shinyWidgets)
library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
library(readxl)

# Import data
#clean_POS_data = read_csv("clean_POS_data.csv",col_names = TRUE)
transcriptions_data = read_csv("full_transcriptions_data.csv", col_names = TRUE)
POS_data = read_csv("POS_data.csv", col_names = TRUE)
speaker_data = read_excel("speaker_info.xlsx")


# Manipulate data
transcriptions_data$Generation = as.factor(transcriptions_data$Generation)
POS_data$Generation = as.factor(POS_data$Generation)
unique_participants = unique(transcriptions_data$Speaker)
unique_languages = unique(transcriptions_data$Language)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #Output for 'the speakers'
    output$speaker_data = DT::renderDataTable({
        datatable(speaker_data,
        options = list(dom = "ltp", lengthMenu = c(10, 20, 30)))
    })
    
    
    # Output for 'search by KWIC' tab
    output$Text_KWIC = DT::renderDataTable({
      POS_data$Speaker = as.factor(POS_data$Speaker)
      datatable(
      if (input$GroupCode_KWIC != "All" & input$GenderCode_KWIC != "All"){
        POS_data %>%
          filter(Language == input$LangCode_KWIC) %>%
          filter(Generation == input$GroupCode_KWIC) %>%
          filter(Gender == input$GenderCode_KWIC) %>%
          filter(grepl(paste0("^", input$Input_KWIC, "$"), token)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_KWIC == "All" & input$GenderCode_KWIC != "All"){
        POS_data %>%
          filter(Language == input$LangCode_KWIC) %>%
          filter(Generation == "first" | Generation == "second") %>%
          filter(Gender == input$GenderCode_KWIC) %>%
          filter(grepl(paste0("^", input$Input_KWIC, "$"), token)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_KWIC != "All" & input$GenderCode_KWIC == "All"){
        POS_data %>%
          filter(Language == input$LangCode_KWIC) %>%
          filter(Generation == input$GroupCode_KWIC) %>%
          filter(Gender == "female" | Gender == "male") %>%
          filter(grepl(paste0("^", input$Input_KWIC, "$"), token)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_KWIC == "All" & input$GenderCode_KWIC == "All"){
        POS_data %>%
          filter(Language == input$LangCode_KWIC) %>%
          filter(Generation == "first" | Generation == "second") %>%
          filter(Gender == "female" | Gender == "male") %>%
          filter(grepl(paste0("^", input$Input_KWIC, "$"), token)) %>%
          select(Sentence, Speaker)
      }, options = list(dom = "ltp", lengthMenu = c(10, 20, 30)))
    })
    
    # Output for 'search by lemma' tab
    output$Text_Lemma = DT::renderDataTable({
      POS_data$Speaker = as.factor(POS_data$Speaker)
      datatable(
      if (input$GroupCode_Lemma != "All" & input$GenderCode_Lemma != "All"){
        POS_data %>%
          filter(Language == input$LangCode_Lemma) %>%
          filter(Generation == input$GroupCode_Lemma) %>%
          filter(Gender == input$GenderCode_Lemma) %>%
          filter(grepl(paste0("^", input$Input_Lemma, "$"), lemma)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_Lemma == "All" & input$GenderCode_Lemma != "All"){
        POS_data %>%
          filter(Language == input$LangCode_Lemma) %>%
          filter(Generation == "first" | Generation == "second") %>%
          filter(Gender == input$GenderCode_Lemma) %>%
          filter(grepl(paste0("^", input$Input_Lemma, "$"), lemma)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_Lemma != "All" & input$GenderCode_Lemma == "All"){
        POS_data %>%
          filter(Language == input$LangCode_Lemma) %>%
          filter(Generation == input$GroupCode_Lemma) %>%
          filter(Gender == "female" | Gender == "male") %>%
          filter(grepl(paste0("^", input$Input_Lemma, "$"), lemma)) %>%
          select(Sentence, Speaker)
      } else if (input$GroupCode_Lemma == "All" & input$GenderCode_Lemma == "All"){
        POS_data %>%
          filter(Language == input$LangCode_Lemma) %>%
          filter(Generation == "first" | Generation == "second") %>%
          filter(Gender == "female" | Gender == "male") %>%
          filter(grepl(paste0("^", input$Input_Lemma, "$"), lemma)) %>%
          select(Sentence, Speaker)
      }, options = list(dom = "ltp", lengthMenu = c(10, 20, 30)))
    })
    
    
    # Output for 'search full transcriptions' tab
    output$Text_FullTra = renderUI({
      transcription_text = transcriptions_data %>%
        filter(Language == input$LangCode_FullTra) %>%
        filter(Speaker == input$PartCode_FullTra) %>%
        pull(Text)
      transcription_sentences = unlist(strsplit(transcription_text, "(?<=(\\.|\\?)\\s)", perl = TRUE))
      HTML(paste0(transcription_sentences, collapse = "<br/>"))
    })
  })
