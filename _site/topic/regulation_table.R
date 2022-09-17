library(dplyr)
library(stringr)
library(dplyr)

# IMPORTANT NOTE ----
## For multiple tables on one html page, the <script>s used cause both tables to disappear. Therefore for table 2, edit the output to only contain only the <body> ... </body> content from the bottom of the document. The scripts in table 1 will be applied on both. You must also comment out the <!DOCTYPE html> for table 1. grep with the flag “-A” to print number of lines “After” match,
# grep -A 20 "<body " regulation_table_summary.html > regulation_table_summary_clean.html

# import ----
df <- read.csv(file="../data/regulation_table.csv", sep= ",")

# reactable ----
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


colnames(df)

df_t <- 
	reactable( df,
				  compact = TRUE,
				  searchable = TRUE,
				  #elementId = "download-table",
				  defaultPageSize = 10,
				  filterable = TRUE,
				  showSortable = TRUE,
				  showPageSizeOptions = TRUE,
				  striped = TRUE,
				  highlight = TRUE,
				  #defaultColDef = colDef(minWidth = 40),
				   
				  columns = list(
				  "Part" = colDef(minWidth = 200),  # overrides the default
				  "Section_details" = colDef(minWidth = 260),  # overrides the default
				  'link' = colDef(minWidth = 400,
				  				  cell = function(link) {
				  	htmltools::tags$a(href = as.character(link), target = "_blank", as.character(link))
				  	# # To give the href and alternative name define 
				  	# url <- df[link == link, "link"]
				  	# htmltools::tags$a(href = as.character(url), target = "_blank", as.character(link))
				  	
				  }),
				  
				  	'Definition' = colDef(style = function(value) {
				  									if (value == "guideline") {color <- "#2dc937" # deep green
				  									} else if (value == "regulation") {color <- "#cc3232" # red
				  									} else if (value == "mandate") {color <- "#db7b2b" # orange
				  									} else if (value == "NA") {color <- "grey"
				  									} else { color <- "black"}
				  									list(color = color) }),
				  
				  'Source' = colDef(
				  	style = function(value) {
				  		if (value == "ICH") {color <- "#063b00" # dark green
				  		} else if (value == "FDA") {color <- "#0f5e9c" # FDA blue
				  		} else if (value == "EMA") {color <- "#a349a4" # EMA purple
				  		} else if (value == "EudraLex") {color <- "#004DB4" # EudraLex blue
				  		} else if (value == "NA") {color <- "grey"
				  		} else { color <- "black"}
				  		list(color = color) }),
				  
				  
				  Relevant_to_our_drug
				  = colDef(cell = function(value) {
				  	# Render as an X mark or check mark
				  	if (value == "None") "\u274c No" else "\u2714\ufe0f Yes"
				  })

				  )

	)

df_t

# colors - traffic lights
#2dc937	# deep green
#99c140	# light green
#e7b416	# yellow
#db7b2b	# orange
#cc3232	# red


# #0f5e9c - FDA Blue
# #a349a4 - EMA purple
# #004DB4 - EudraLex blue
# #063b00 - ICH dark green

library(reactablefmtr)
save_reactable(df_t, "../output/regulation_table.html")

df_summary <- df %>% select(Source, Document) %>% unique() %>% arrange(Source) %>% mutate_all(na_if,"") %>% na.omit()

df_summary_t <- 
	reactable( df_summary,
				  compact = TRUE,
				  defaultPageSize = 20,
				  striped = TRUE,
				  highlight = TRUE,
				  columns = list(

				  	'Source' = colDef(
				  		style = function(value) {
				  			if (value == "ICH") {color <- "#063b00" # dark green
				  			} else if (value == "FDA") {color <- "#0f5e9c" # FDA blue
				  			} else if (value == "EMA") {color <- "#a349a4" # EMA purple
				  			} else if (value == "EudraLex") {color <- "#004DB4" # EudraLex blue
				  			} else if (value == "NA") {color <- "grey"
				  			} else { color <- "black"}
				  			list(color = color) })

				  )
	)

df_summary_t
save_reactable(df_summary_t, "../output/regulation_table_summary.html")
