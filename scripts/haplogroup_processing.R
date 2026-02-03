library(networkD3)
library(htmlwidgets) 
library(dplyr)
library(stringr)

.derive_MacroPhylo <- function(Hgsubgroup_col, oneletter_col) {
  case_when(
    str_starts(Hgsubgroup_col, "L0") ~ "L0",
    str_starts(Hgsubgroup_col, "L1") ~ "L1",
    str_starts(Hgsubgroup_col, "L2") ~ "L2",
    str_starts(Hgsubgroup_col, "L3") ~ "L3",
    str_starts(Hgsubgroup_col, "L4") ~ "L4",
    str_starts(Hgsubgroup_col, "L5") ~ "L5",
    str_starts(Hgsubgroup_col, "L6") ~ "L6",
    str_starts(Hgsubgroup_col, "M7") ~ "M7",
    str_starts(Hgsubgroup_col, "M8") ~ "M8",
    str_detect(oneletter_col, "C") ~ "M8",
    str_detect(oneletter_col, "Z") ~ "M8",
    str_starts(Hgsubgroup_col, "M9") ~ "M9",
    str_detect(oneletter_col, "E") ~ "M9",
    str_detect(oneletter_col, "G") ~ "G",
    str_detect(oneletter_col, "D") ~ "D",
    str_starts(Hgsubgroup_col, "N1") ~ "N1",
    str_starts(oneletter_col, "I") ~ "N1",
    str_starts(Hgsubgroup_col, "N2") ~ "N2",
    str_starts(oneletter_col, "W") ~ "N2",
    str_starts(Hgsubgroup_col, "N9") ~ "N9",
    str_starts(Hgsubgroup_col, "Y") ~ "N9",
    str_detect(oneletter_col, "NOS") ~ "N*",
    str_detect(oneletter_col, "N") ~ "N*",
    str_detect(oneletter_col, "O") ~ "N*",
    str_detect(oneletter_col, "S") ~ "N*",
    str_detect(oneletter_col, "A") ~ "A",
    str_detect(oneletter_col, "X") ~ "X",
    str_starts(Hgsubgroup_col, "R0") ~ "R0",
    str_detect(oneletter_col, "HV") ~ "HV",
    str_detect(oneletter_col, "H") ~ "HV",
    str_detect(oneletter_col, "V") ~ "HV",
    str_detect(oneletter_col, "JT") ~ "JT",
    str_detect(oneletter_col, "J") ~ "JT",
    str_detect(oneletter_col, "T") ~ "JT",
    str_starts(Hgsubgroup_col, "R9") ~ "R9",
    str_detect(oneletter_col, "F") ~ "R9",
    str_starts(oneletter_col, "B") ~ "B",
    str_detect(oneletter_col, "RP") ~ "R*",
    str_detect(oneletter_col, "R") ~ "R*",
    str_detect(oneletter_col, "P") ~ "R*",
    str_detect(oneletter_col, "UK") ~ "UK",
    str_detect(oneletter_col, "U") ~ "UK",
    str_detect(oneletter_col, "K") ~ "UK",
    str_detect(oneletter_col, "MQ") ~ "M*",
    str_detect(oneletter_col, "M") ~ "M*",
    str_detect(oneletter_col, "Q") ~ "M*",
    .default = NA_character_ # Handle cases where no match is found
  )
}

get_Supergroups <- function(df) {
  df %>%
    dplyr::mutate(
      hg1_MacroPhylo = .derive_MacroPhylo(hg1_Hgsubgroup, hg1_oneletter),
      hg2_MacroPhylo = .derive_MacroPhylo(hg2_Hgsubgroup, hg2_oneletter)
    )
}


process_haplogroup_data <- function(array_type,
                                    array_file_path,
                                    haplogrep_input_file,
                                    output_base_name) {
  
  # 1. Setup Folders
  plot_dir <- "plots"
  output_dir <- "output"
  
  if (!dir.exists(plot_dir)) dir.create(plot_dir)
  if (!dir.exists(output_dir)) dir.create(output_dir)
  
  jar_path <- file.path("..", "..", "bin", "haplogrep.jar")
  
  message(paste("--- Processing", array_type, "data ---"))
  
  # Read the specific array file
  microArray <- read.delim(array_file_path, sep = "\t", header = FALSE)
  arrayPos <- paste(microArray[[3]], collapse = ";")
  
  # 2. Define output paths INSIDE the output folder
  temp_haplogrep_input_file <- file.path(output_dir, paste0("temp_haplogrep_input_", output_base_name, ".hsd"))
  outputfile_haplogrep <- file.path(output_dir, paste0(output_base_name, "_haplogrep_out.txt"))
  haplogroup_distcheck_file <- file.path(output_dir, paste0(output_base_name, "_haplogroup_distcheck.txt"))
  haplogroup_distcheck_result_file <- file.path(output_dir, paste0(output_base_name, "_haplogroup_distcheck_result.txt"))
  
  hsd_data <- read.delim(haplogrep_input_file)
  hsd_data[[3]] <- ""
  hsd_data[[2]] <- arrayPos
  hsd_data <- hsd_data[, colSums(is.na(hsd_data)) == 0]
  hsd_data <- hsd_data[hsd_data$SampleID != "mt-MRCA", ]
  
  write.table(hsd_data, file = temp_haplogrep_input_file, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
  
  # Run HaploGrep2 classify
  if (!file.exists(outputfile_haplogrep)) {
    cmd_classify <- paste(
      "java -jar", shQuote(jar_path), " classify ",
      "--in", shQuote(temp_haplogrep_input_file),
      "--format hsd",
      "--phylotree", shQuote(phylotreeVersion),
      "--out", shQuote(outputfile_haplogrep)
    )
    system(cmd_classify)
  }
  
  # Process classified results
  haplogroups <- read.delim(outputfile_haplogrep, sep = "\t", header = TRUE)
  haplogroupsList <- haplogroups %>% select(SampleID, Haplogroup)
  colnames(haplogroupsList) <- c("hg1", "hg2")
  write.table(haplogroupsList, file = haplogroup_distcheck_file, sep = ";", row.names = FALSE, col.names = TRUE, quote = FALSE)
  
  # Run HaploGrep2 distance
  cmd_distance <- paste(
    "java -jar", shQuote(jar_path), " distance ",
    "--in", shQuote(haplogroup_distcheck_file),
    "--out", shQuote(haplogroup_distcheck_result_file)
  )
  system(cmd_distance)
  
  # Read and process distance output
  if (file.exists(haplogroup_distcheck_result_file)) {
    haplogroupsDiff <- read.delim(haplogroup_distcheck_result_file, sep = ";", header = TRUE)
    
    # 1. Extract haplogroup subgroups and letters for categorization
    haplogroupsDiff$hg1_Hgsubgroup <- str_extract(haplogroupsDiff$hg1, "[A-z]{1,4}+\\d*")
    haplogroupsDiff$hg1_oneletter <- str_extract(haplogroupsDiff$hg1, "[A-z]*")
    haplogroupsDiff$hg2_Hgsubgroup <- str_extract(haplogroupsDiff$hg2, "[A-z]{1,4}+\\d*")
    haplogroupsDiff$hg2_oneletter <- str_extract(haplogroupsDiff$hg2, "[A-z]*")
    
    # 2. Derive MacroPhylo groups
    haplogroupsDiff <- get_Supergroups(haplogroupsDiff)
    
    # 3. Prepare data for Sankey links
    plot_data_prep <- haplogroupsDiff %>%
      mutate(
        MacroPhylo_hg1 = ifelse(is.na(hg1_MacroPhylo), "Unknown", hg1_MacroPhylo),
        MacroPhylo_hg2 = ifelse(is.na(hg2_MacroPhylo), "Unknown", hg2_MacroPhylo)
      ) %>%
      group_by(MacroPhylo_hg1, MacroPhylo_hg2) %>%
      summarise(Count = n(), .groups = 'drop')
    
    # 4. Create Nodes (Unique names for Source and Target)
    source_nodes <- paste0("HG1: ", unique(plot_data_prep$MacroPhylo_hg1))
    target_nodes <- paste0("HG2: ", unique(plot_data_prep$MacroPhylo_hg2))
    all_node_names <- unique(c(source_nodes, target_nodes))
    
    nodes_df <- data.frame(
      name = all_node_names,
      group = stringr::str_remove(all_node_names, "^HG[12]: ")
    )
    nodes_df$id <- 0:(nrow(nodes_df) - 1)
    
    # 5. Create Links (The missing 'links_df')
    links_df <- plot_data_prep %>%
      mutate(Source_Prefixed = paste0("HG1: ", MacroPhylo_hg1),
             Target_Prefixed = paste0("HG2: ", MacroPhylo_hg2)) %>%
      left_join(nodes_df, by = c("Source_Prefixed" = "name")) %>%
      rename(source_id = id) %>%
      left_join(nodes_df, by = c("Target_Prefixed" = "name")) %>%
      rename(target_id = id) %>%
      select(source = source_id, target = target_id, value = Count) 
    # Create the Sankey plot
    sankey_plot <- sankeyNetwork(Links = links_df, Nodes = nodes_df,
                                 Source = "source", Target = "target",
                                 Value = "value", NodeID = "name",
                                 NodeGroup = "group",
                                 units = "samples", fontSize = 12, nodeWidth = 30,
                                 colourScale = JS('d3.scaleOrdinal(d3.schemeCategory10);'))
    
    # 3. Save the Sankey Plot to the plots folder
    plot_file_path <- file.path(plot_dir, paste0(output_base_name, "_sankey.html"))
    saveWidget(sankey_plot, file = plot_file_path, selfcontained = TRUE)
    message(paste("Sankey plot saved to:", plot_file_path))
    
    return(list(
      haplogroupsDiff = haplogroupsDiff,
      sankey_plot = sankey_plot
    ))
    
  } else {
    warning("Haplogroup distance result file not found.")
    return(NULL)
  }
}

