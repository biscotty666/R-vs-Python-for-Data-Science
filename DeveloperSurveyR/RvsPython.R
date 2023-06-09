## ------------------------------------------------------------------------
library(tidyverse)

## ------------------------------------------------------------------------
library(tidytable)


## ------------------------------------------------------------------------

# download.file("https://raw.githubusercontent.com/JovianML/opendatasets/master/data/stackoverflow-developer-survey-2020/survey_results_schema.csv", "survey_results_schema.csv")


## ------------------------------------------------------------------------
# download.file("https://raw.githubusercontent.com/JovianML/opendatasets/master/data/stackoverflow-developer-survey-2020/survey_results_public.csv", "survey_results_public.csv")


## ------------------------------------------------------------------------
# download.file("https://raw.githubusercontent.com/JovianML/opendatasets/master/data/stackoverflow-developer-survey-2020/README.txt", "README.txt")


## ------------------------------------------------------------------------
survey_raw_df <- read_csv("survey_results_public.csv")

## ------------------------------------------------------------------------
survey_raw_df

## ------------------------------------------------------------------------
schema_raw_df <- read_csv("survey_results_schema.csv")
schema_raw_df

## ------------------------------------------------------------------------
str(schema_raw_df)

## ------------------------------------------------------------------------
schema_raw_df[1]

## ------------------------------------------------------------------------
ind <- schema_raw_df$Column == "YearsCodePro"
schema_raw_df$QuestionText[ind]

## ------------------------------------------------------------------------
selected_columns <- c("Country", "Age", "Gender", "EdLevel", "UndergradMajor",
                      "Hobbyist", "Age1stCode", "YearsCode", "YearsCodePro",
                      "LanguageWorkedWith", "LanguageDesireNextYear", 
                      "NEWLearn", "NEWStuck", "Employment", "DevType", 
                      "WorkWeekHrs", "JobSat", "JobFactors",
                      "NEWOvertime", "NEWEdImpt")
length(selected_columns)

## ------------------------------------------------------------------------
survey_df <- survey_raw_df %>%
  select(all_of(selected_columns))


## ------------------------------------------------------------------------
ind <- which(schema_raw_df$Column %in% selected_columns)
schema <- schema_raw_df[ind,]
schema


## ------------------------------------------------------------------------
str(survey_df)

## ------------------------------------------------------------------------
survey_df |>
  mutate(
    Age1stCode = as.numeric(Age1stCode),
    YearsCode = as.numeric(YearsCode),
    YearsCodePro = as.numeric(YearsCodePro)
  ) -> survey_df
str(survey_df)

## ------------------------------------------------------------------------
summary(survey_df)

## ------------------------------------------------------------------------
# survey_df |>
#  filter(Age >= 10 & Age <= 100) |>
#  filter(WorkWeekHrs <= 140) -> survey_df


## ------------------------------------------------------------------------
survey_df |>
  summarise(Age = n(), .by = Gender)


## ------------------------------------------------------------------------
survey_df |>
  filter(Age >= 10 | is.na(Age)) |>
  filter(WorkWeekHrs <= 140 | is.na(WorkWeekHrs)) |>
  summarise(Age = n(), .by = Gender)


## ------------------------------------------------------------------------
survey_df %>% 
  mutate(Gender = if_else(grepl(";", Gender), NA, Gender)) -> survey_df


## ------------------------------------------------------------------------
survey_df |>
  summarise(Age = n(), .by = Gender)


## ------------------------------------------------------------------------
survey_df |> sample(10)


## ------------------------------------------------------------------------
ind_country <- schema$Column == "Country"
schema$QuestionText[ind_country]

## ------------------------------------------------------------------------
country_question <- schema$QuestionText[schema$Column == "Country"]

## ------------------------------------------------------------------------
length(unique(survey_df$Country))

## ------------------------------------------------------------------------
survey_df |>
  summarise(Count = n(), .by = Country) |>
  top_n(n = 15, wt = Count) |>
  mutate(Country = reorder(Country, Count, decreasing = TRUE)) -> top_countries
top_countries


## ------------------------------------------------------------------------
top_countries |>
  ggplot(aes(x = Country, y = Count, fill = Country)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  ggtitle(country_question) +
  theme(axis.text.x = element_text(angle=75, vjust=1, hjust = 1))


## ------------------------------------------------------------------------
survey_df |>
  ggplot(aes(Age)) +
  geom_histogram(binwidth = 5, colour = "black", fill="purple") +
  scale_x_continuous(name = "Age",
                   breaks = seq(10, 80, 10)) +
  xlim(10, 80) +
  ylab("Number of respondents")

