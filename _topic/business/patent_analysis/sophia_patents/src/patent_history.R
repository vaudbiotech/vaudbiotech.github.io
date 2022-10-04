library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)
library(ggplot2)

# Custom_interpretation field added

# import ----
df <- read.csv(file="../data/gp-search-20220923-052404.csv",
							 sep= ",", 
							 skip=1, 
							 header=T)

# dates ----
df$priority.date <- lubridate::dmy(df$priority.date)
df$filing.creation.date <- lubridate::dmy(df$filing.creation.date)
df$grant.date <- lubridate::dmy(df$grant.date)
df$publication.date <- lubridate::dmy(df$publication.date)

names(df)

# Standardised inventor name cases ----
df$inventor.author <- str_to_title(df$inventor.author, locale = "en")

# reshape and format ----
df2 <- gather(df, "priority.date", "filing.creation.date", "grant.date", "publication.date", key = "event", value = "date")

df2$date <- as.Date(as.character(df2$date))

df2 %>%
	group_by(event, id) %>%
	filter(id == "US-10402588-B2") %>%
ggplot(aes(date, id)) +
	geom_line(size = 5) +
	#scale_color_manual(values=event, name="Project component") +
	labs(x="Project year", y=NULL, title="Project timeline")

currentDate <- Sys.Date()
print(currentDate)


df3 <-
	df2 %>% 
	group_by(id) %>% 
	summarise(add_row(cur_data(), event = "date.current", 
										date = 	currentDate
	)) %>%
	filter(event == "date.current") %>%
	select(id, date)

# colnames(df)[colnames(df) == 'oldName'] <- 'newName'
colnames(df3)[colnames(df3) == 'date'] <- 'date.current'

#df3 <- df3 %>% arrange(ymd(df3$date.current))

df4 <- merge(df2,df3)

df5 <- gather(df4, "date", "date.current", key = "status", value = "date") 

# reorder best on the earliest date event
df5$event = with(df5, reorder(event, date, min))

# plot ----
# library(forcats)
p <- df5 %>%
	arrange(date) %>%
	group_by(id, event) %>%
#	filter(id == "US-10402588-B2") %>%
	ggplot(aes(date, event, color = event)) +
	geom_line(size = 1) +
	facet_grid(Custom_interpretation + id ~., switch = "y") +
	
	theme(axis.text.y=element_blank(),
			axis.ticks.y=element_blank(),
			# facet labels
			strip.text.y.left = element_text(angle = 0),
			legend.position="bottom"
	) +
	labs(x = "Date",
		  y = "Patent event",
		  title = "Patent events for Sophia Genetics SA",
		  subtitle = "as of date 20220930",
		  #caption = "Data source: ToothGrowth"
)
	
library(cowplot)
ggdraw(p) +
	 draw_label("LawlessGenomics.com", 
						 color = "grey",
						 size = 10, 
						 angle = 45)

# sophiagenetics_patents.pdf 8x8
# sophiagenetics_patents.png 800x800


# reactable ----
# remove the duplicate required for figure
df6 <- df5 %>%
	filter(status == "date") %>%
	select(-status)

# install.packages("reactable")
library(reactable)

options(reactable.theme = reactableTheme(
	borderColor = "#dfe2e5",
	stripedColor = "#E5E5E5",
	highlightColor = "#fcf0e6",
	cellPadding = "8px 12px",
	style = list(fontFamily = "-apple-system, Arial, BlinkMacSystemFont, Segoe UI, Helvetica,  sans-serif",
					 fontSize = "0.8rem"),
	searchInputStyle = list(width = "50%")
))

colnames(df6)

df6$date <- as.character(df6$date)
df6$date <- df6$date %>% replace_na('incomplete') 


main_table <- df6
main_table <- main_table %>% select(-inventor.author, everything(), inventor.author)

df_t <- 
	reactable( main_table,
				  compact = TRUE,
				  searchable = TRUE,
				  resizable = TRUE,
				  #elementId = "download-table",
				  defaultPageSize = 10,
				  filterable = TRUE,
				  showSortable = TRUE,
				  showPageSizeOptions = TRUE,
				  striped = TRUE,
				  highlight = TRUE,
				  defaultColDef = colDef(minWidth = 200),
				  
				  columns = list(
				  	"id" = colDef(minWidth = 200),  # overrides the default
				  	"inventor.author" = colDef(
				  		minWidth = 360
				  		), 
				  	"date" = colDef(minWidth = 100),  # overrides the default
				  	"title" = colDef(minWidth = 260),  # overrides the default
				  	'result.link' = colDef(minWidth = 360,
				  						 cell = function(result.link) {
				  						 	htmltools::tags$a(href = as.character(result.link), target = "_blank", as.character(result.link))
				  						 	# # To give the href and alternative name define 
				  						 	# url <- df[link == link, "link"]
				  						 	# htmltools::tags$a(href = as.character(url), target = "_blank", as.character(link))
				  						 	
				  						 }),
				  	
				  	'representative.figure.link' = colDef(minWidth = 360,
				  								  cell = function(representative.figure.link) {
				  								  	htmltools::tags$a(href = as.character(representative.figure.link), target = "_blank", as.character(representative.figure.link))
				  								  	# # To give the href and alternative name define 
				  								  	# url <- df[link == link, "link"]
				  								  	# htmltools::tags$a(href = as.character(url), target = "_blank", as.character(link))
				  								  	
				  								  }),
				  	
				  	'Custom_interpretation' = colDef(style = function(value) {
				  		if (value == "data_handling") {color <- "#0f5e9c" # fda blue
				  		} else if (value == "data_analysis_protocol") {color <- "#cc3232" # red
				  		} else if (value == "graphic_display") {color <- "#db7b2b" # orange
				  		} else if (value == "wet-lab_analysis") {color <- "#063b00" # dark green
				  		} else if (value == "NA") {color <- "grey"
				  		} else { color <- "black"}
				  		list(color = color) })
				  	
				  	# event
				  	# = colDef(cell = function(value) {
				  	# 	# Render as an X mark or check mark
				  	# 	if (value == "publication.date") "\u274c No" else "\u2714\ufe0f Yes"
				  	# })
				  	
				  )
				  
	)

df_t
library(reactablefmtr)
save_reactable(df_t, "../output/patent_history_sophiagenetics.html")

# colors - traffic lights
# "#a349a4" # EMA purple
# "#004DB4" # EudraLex blue
# "#0f5e9c" # FDA blue
# "#063b00" # dark green
#2dc937	# deep green
#99c140	# light green
#e7b416	# yellow
#db7b2b	# orange
#cc3232	# red


# clean html ----
system("grep -v '<!DOCTYPE html' ../output/patent_history_sophiagenetics.html > ../output/patent_history_sophiagenetics_clean.html")
# For multiple tables on one html page, the <script>s used cause both tables to disappear. Therefore for table 2, edit the output to only contain only the <body> ... </body> content from the bottom of the documen    t. The scripts in table 1 will be applied on both. You must also comment out the <!DOCTYPE html> for table 1. grep with the flag “-A” to print number of lines “After” match.
# grep -A 20 "<body " patent_history_sophiagenetics.html | grep -v "</html>" > patent_history_sophiagenetics_clean.html
