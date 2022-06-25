library(shiny)
library(shinythemes)
library(shinyWidgets)
library(vov)
library(tidyverse)
library(dplyr)
library(DT)
library(readxl)


# Import data
transcriptions_data = read_csv("full_transcriptions_data.csv", col_names = TRUE)
POS_data = read_csv("POS_data.csv", col_names = TRUE)
speaker_data = read_excel("speaker_info.xlsx")

# Manipulate data
transcriptions_data$Generation = as.factor(transcriptions_data$Generation)
POS_data$Generation = as.factor(POS_data$Generation)
unique_participants = unique(transcriptions_data$Speaker)
unique_languages = unique(transcriptions_data$Language)


#Background Image CSS
backgroundImageCSS <- "background-color: #cccccc;
                       height: 91vh;
                       background-position: center;
                       background-repeat: no-repeat;
                       background-size: cover; 
                       background-image: url('%s');
                       "

# Define UI for application
shinyUI(fluidPage(
  
  tags$head(
    tags$style(HTML("@import url('https://urldefense.com/v3/__https://fonts.googleapis.com/css?family=Raleway:300,700__;!!DZ3fjg!sJqFeY5byrv8YVrwLzuVc1IT69Pkz_VDLzZhBFloqBpdVMIraCiUCBrY9k-V5k55bPP72Q$ ');
                    body {
                      font-family: 'Raleway', sans-serif;
                      font-weight: 300;
                      background-color: white;
                      color: rgb(15, 12, 19);
                    }
                    h1, h2, h3, h4, h5, h6 {
                      font-family: 'Raleway', sans-serif;
                      font-weight: 900;
                      letter-spacing: 2px;
                    }
                    ")),
    tags$head(includeHTML(("google-analytics.html")))
  ),
  
  theme = shinytheme("sandstone"),
                  
                  # Add title to the UI
                  titlePanel(""),
                  
                  # Add navigation panel
                  navbarPage(" ",
                             
                             # Add 'home' tab
                             tabPanel(icon("home"),
                                      fluidRow(style = sprintf(backgroundImageCSS,"https://wallpapercave.com/wp/wp4943520.jpg",encoding=22),
                                               tags$head(tags$style('h1 {color:white;}')),tags$head(tags$style('h2 {color:white;}')),
                                               column(12,use_vov(),fade_in(h1("Bilinguals in the Midwest (BILinMID) Corpus", align = "center")),style = "margin-top: 215px;"),
                                               column(12,use_vov(),fade_in(h2("A Spanish-English Corpus", align = "center")))
                                  )),
                
                             # Add 'about' tab
                             tabPanel("About this corpus",
                                      fluidRow(tags$head(tags$style('h4 {color:black;}')),
                                        column(9, h4("About the Bilinguals in the Midwest (BILinMID) Corpus", align = "left")),
                                        column(9, tags$div(HTML("The Bilinguals in the Midwest (BILinMID) Corpus aims to document the Spanish and English spoken in the U.S. Midwest. 
                                                                 This digital corpus comprises annotated transcriptions of the Little Red Riding Hood fairy tale, as narrated by various groups of bilingual speakers. 
                                                                 The stories were elicited orally using pictures from a children’s book which have also been used in previous studies with bilingual speakers (e.g., Cuza et al., 2013; Montrul, 2004, 2010). 
                                                                 Currently, the corpus does not contain the audio recordings.<p>&nbsp;</p>"))),
                                        column(9, tags$div(HTML("So far, data from 82 speakers have been collected between January 2021 and April 2022. 
                                                                 Speakers belong to three different groups, namely early simultaneous bilinguals (N = 7), early sequential bilinguals (N = 40), and late L2 learners (N = 35). 
                                                                 The terminology chosen is informative of the specific language developmental pattern from each group. 
                                                                 In the near future, more data will be collected and processed to increase the size of the corpus. 
                                                                 For more information about the data collection process as well as about the development of the corpus, please see Hurtado (2022), where a more detailed description is provided.<p>&nbsp;</p>"))),
                                        column(9, tags$div(HTML("The BILinMID Corpus is meant to inform scholars interested in sociolinguistic variation, bilingualism, and contact languages. 
                                                                At the same time, the corpus also intends to raise awareness on the different dialects or language varieties spoken in the Midwest region of the U.S., 
                                                                which has seen its Latino/Hispanic population rapidly grow in recent years (Potowski, 2020).<p>&nbsp;</p>"))),
                                        column(9, h4("How to cite the corpus", align = "left")),
                                        column(9, tags$div(HTML("To cite the corpus, please use the following reference: 
                                                                Hurtado, I. (2022). BILinMID. A Spanish-English Corpus of the US Midwest. 
                                                                <i>Proceedings of the 13th Conference on Language Resources and Evaluation (LREC)</i>. ELRA. (<a href='http://www.lrec-conf.org/proceedings/lrec2022/pdf/2022.lrec-1.590.pdf'>Link</a>)
                                                                <p>&nbsp;</p>"))),
                                        column(9, h4("Research team and contact", align = "left")),
                                        column(9, tags$div(HTML("<b>Project Lead</b></br> 
                                                                Irati Hurtado, PhD Candidate in Spanish Linguistics, University of Illinois, Urbana-Champaign (<a href='mailto:ihurta3@illinois.edu'>ihurta3@illinois.edu</a>)</br>
                                                                <b>Research Assistants</b></br>
                                                                J. Canty (Spring 2022)</br>
                                                                J. Vazquez (Spring 2022)</br>
                                                                A. Andino (Fall 2021)</br>
                                                                A. Seielstad (Fall 2021)</br>
                                                                P. Renteria (Spring 2021)
                                                                <p>&nbsp;</p>"))),
                                        column(9, tags$div(HTML("<p>&nbsp;</p>The Bilinguals in the Midwest (BILinMID) Corpus is licensed under a
                                                                Creative Commons CC BY License.
                                                                <p>&nbsp;</p>")))
                                      )),
                             
                             # Add 'how to use this corpus' tab
                             tabPanel("How to use this corpus",
                                      fluidRow(tags$head(tags$style('h4 {color:black;}')),
                                      column(9, h4("How to use this corpus", align = "left")),
                                      column(9, tags$div(HTML("There are different ways to explore the corpus using the various tabs at the top.<p>&nbsp;</p>
                                                              <b>The Speakers</b></br>
                                                              This tab contains information about the 72 speakers whose narratives are part of the corpus. 
                                                              Each speaker is anonymously identified by a unique 3-digit code. 
                                                              The information reported here comes from a questionnaire speakers completed prior to being recorded. 
                                                              Besides providing basic demographic information (e.g., gender, age, country of origin), speakers also completed the Bilingual Language Profile (BLP) (Birdsong et al., 2012) 
                                                              to assess their language dominance. Their BLP scores are also reported in the table.<p>&nbsp;</p>"))),
                                      column(9, tags$div(HTML("<b>Search by KWIC</b></br>
                                                              This tab allows to query the corpus using a “keyword in context” (KWIC) approach. 
                                                              Additionally, it is also possible to filter out the data based on language, generation, and gender. 
                                                              To execute a query, simply enter a keyword in the search bar. 
                                                              A table will show up on the right side of the page listing all sentences that contain such keyword. 
                                                              The table also indicates the speaker who produced each sentence using an anonymous 3-digit code. 
                                                              To learn more about a speaker, you can visit The Speakers tab.</br> 
                                                              Please, note that the search bar is case-sensitive.<p>&nbsp;</p>"))),
                                      column(9, tags$div(HTML("<b>Search by Lemma</b></br>
                                                              This tab allows to query the corpus based on a lemma (i.e., dictionary form of a word). 
                                                              Additionally, it is also possible to filter out the data based on language, generation, and gender. 
                                                              To execute a query, simply enter a lemma in the search bar. 
                                                              For example, searching for the lemma 'eat' will identify all sentences containing that verb in any form (e.g., “eating”, “ate”, “eats”). 
                                                              A table will show up on the right side of the page listing all sentences that contain such lemma. 
                                                              The table also indicates the speaker who produced each sentence using an anonymous 3-digit code. 
                                                              To learn more about a speaker, you can visit The Speakers tab.</br> 
                                                              Please, note that the search bar is case-sensitive.<p>&nbsp;</p>"))),
                                      column(9, tags$div(HTML("<b>Search Full Transcriptions</b></br>
                                                              This tab allows to retrieve the full transcription of a given speaker. 
                                                              Simply select a language and a speaker, and the transcription will appear on the right side of the page. 
                                                              All transcriptions follow the CHAT format (MacWhinney, 2000), which means that they include some special symbols to indicate pauses, retracings, code-switching, and other phenomena. 
                                                              <p>&nbsp;</p>")))
                                      )),
                             
                             # Add 'speakers' tab
                             tabPanel("The speakers",
                                fluidRow(column(DT::dataTableOutput("speaker_data"), width = 12))),
                             
                  
                             
                             # Add 'search by KWIC' tab
                             tabPanel("Search by KWIC",
                                sidebarLayout(
                                  
                                  # Add sidebar to the 'search by KWIC' tab
                                  sidebarPanel(
                                    textInput("Input_KWIC", "Enter a keyword:"),
                                    radioButtons("LangCode_KWIC", "Language", c("English" = "eng", "Spanish" = "spa")),
                                    radioButtons("GroupCode_KWIC", "Generation", c("All", "First Generation" = "first", "Second Generation" = "second"), selected = "All"),
                                    radioButtons("GenderCode_KWIC", "Gender", c("All", "Male" = "male", "Female" = "female"), selected = "All")),
                                  
                                  # Add main panel to the 'search by KWIC' tab
                                  mainPanel(DT::dataTableOutput("Text_KWIC")))),
                             
                             # Add 'search by lemma' tab
                             tabPanel("Search by lemma",
                                sidebarLayout(
                                    
                                  # Add sidebar to the 'search by lemma' tab
                                  sidebarPanel(
                                    textInput("Input_Lemma", "Enter a lemma:"),
                                    radioButtons("LangCode_Lemma", "Language", c("English" = "eng", "Spanish" = "spa")),
                                    radioButtons("GroupCode_Lemma", "Generation", c("All", "First Generation" = "first", "Second Generation" = "second"), selected = "All"),
                                    radioButtons("GenderCode_Lemma", "Gender", c("All", "Male" = "male", "Female" = "female"), selected = "All")),
                                  
                                  # Add main panel to the 'search by lemma' tab
                                  mainPanel(DT::dataTableOutput("Text_Lemma")))),
                             
                             # Add 'search full transcriptions' tab
                             tabPanel("Search full transcriptions",
                                sidebarLayout(
                                  
                                  # Add sidebar to the 'search full transcriptions' tab
                                  sidebarPanel(
                                    radioButtons("LangCode_FullTra", "Choose a language", c("English" = "eng", "Spanish" = "spa")),
                                                 selectInput("PartCode_FullTra", "Choose a speaker", c("", unique_participants))),
                                  
                                  # Add main panel to the 'search full transcriptions' tab
                                  mainPanel(htmlOutput("Text_FullTra"))))

                             )))
