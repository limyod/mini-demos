## Let's make a webscraper!
## Sources:
##   https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/
##   https://www.rdocumentation.org/packages/rvest/versions/0.3.2/topics/html_nodes
##   https://www.rdocumentation.org/packages/rvest/versions/0.3.2/topics/html_text


## Uncomment this to install packages
# install.packages('rvest')

# Load in 'rvest' package
library("rvest")

"Specify the URL endpoint we are using"
url <- "http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature"
webpage <- read_html(url)

# html_nodes: More easily extract pieces out of HTML documents using XPath and css selectors
# html_text: Extract attributes, text and tag name from html.

rank_data_html <- html_nodes(webpage, ".text-primary")
rank_data <- html_text(rank_data_html)

head(rank_data)

rank_data <- as.numeric(rank_data)
head(rank_data)

# Using CSS selectors to scrape the title section
title_data_html <- html_nodes(webpage, ".lister-item-header a")

# html to text
title_data <- html_text(title_data_html)
# look at data
title_data
# Using CSS selectors to scrape the description section
description_data_html <- html_nodes(webpage, ".ratings-bar+ .text-muted")
# Converting the description data to text
description_data <- html_text(description_data_html)
# look at data
description_data
# Data-Preprocessing: removing '\n'
description_data <- gsub("\n", "", description_data)
# Using CSS selectors to scrap the Movie runtime section
runtime_data_html <- html_nodes(webpage, ".text-muted .runtime")
# Converting the movie runtime data to text
runtime_data <- html_text(runtime_data_html)
# Let's have a look at the movie runtime
head(runtime_data)
# Data-Preprocessing: removing mins and converting it to numerical
runtime_data <- gsub(" min", "", runtime_data)
runtime_data <- as.numeric(runtime_data)

# Let's have another look at the runtime data
runtime_data

# Converting the genre data to text
genre_data_html <- html_nodes(webpage, ".genre")
genre_data <- html_text(genre_data_html)

# Let's have a look at the genre

# Data-Preprocessing: removing \n

# Data-Preprocessing: removing excess spaces

# taking only the first genre of each movie

# Convering each genre from text to factor

# Let's have another look at the genre data

# Using CSS selectors to scrap the IMDB rating section

# Converting the ratings data to text

# Let's have a look at the ratings

# Data-Preprocessing: converting ratings to numerical

# Let's have another look at the ratings data


# Using CSS selectors to scrap the directors section

# Converting the directors data to text

# Let's have a look at the directors data

# Data-Preprocessing: converting directors data into factors

# Using CSS selectors to scrap the actors section

# Converting the gross actors data to text

# Let's have a look at the actors data

# Data-Preprocessing: converting actors data into factors

# Using CSS selectors to scrap the gross revenue section
gross_data_html <- html_nodes(webpage, ".ghost~ .text-muted+ span")
# Converting the gross revenue data to text
gross_data <- html_text(gross_data_html)
# Let's have a look at the votes data
head(gross_data)

# Data-Preprocessing: removing '$' and 'M' signs


# Let's check the length of gross data
length(gross_data)
gross_data <- gsub("M", "", gross_data)
gross_data <- substring(gross_data, 2, 6)

length(gross_data)


# Filling missing entries with NA
for (i in c(73, 74, 76, 77, 80, 87, 88, 89)) {
  a <- gross_data[1:(i - 1)]

  b <- gross_data[i:length(gross_data)]

  gross_data <- append(a, list("NA"))

  gross_data <- append(gross_data, b)
}

# Data-Preprocessing: converting gross to numerical
gross_data <- as.numeric(gross_data)
# Let's have another look at the length of gross data
length(gross_data)

summary(gross_data)


movies_df <- data.frame(
  Rank = rank_data, Title = title_data,

  Description = description_data, Runtime = runtime_data,

  Genre = genre_data, Gross_Earning_in_Mil = gross_data


)

library("ggplot2")
qplot(data = movies_df, Runtime, fill = Genre, bins = 30)
# let's draw some plots!
ggplot(movies_df, aes(x = Runtime, y = Gross_Earning_in_Mil)) +
  geom_point(aes(size = Rating, col = Genre))
