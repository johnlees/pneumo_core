library(readxl)
core_cls_names <- read_excel("core_cls_names.xlsx")
core_cls_names = core_cls_names[,-2]
colnames(core_cls_names)[2] = "Gene name"

avg_aa_length <- read.delim("avg_aa_length.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(avg_aa_length) = c("COG", "Average_aa_length")

slac_results <- dplyr::as_data_frame(read_csv("slac_results.txt", col_names = FALSE))
colnames(slac_results) = c("COG", "Aligned_sites", "dS", "dN", "omega")
slac_results = bind_rows(slac_results, nanA_slac)

aa_pis <- dplyr::as_data_frame(read.table("aa_pis.txt", header = F, sep = "\t", stringsAsFactors = F))
colnames(aa_pis) = c("COG", "pi_aa")
slac_results = inner_join(slac_results, aa_pis)
slac_results = inner_join(avg_aa_length, slac_results)
slac_results = inner_join(core_cls_names, slac_results)

slac_results = slac_results %>%
  mutate(dN_rate = dN/Aligned_sites, pi_gene = pi_aa*Average_aa_length) %>%
  filter(omega < 5)

write.table(slac_results, file = "core_gene_stats.csv", quote = F, sep = ",", row.names = F)

library(scatterD3)
scatterD3(x = slac_results$pi_gene,
          y = slac_results$omega,
          xlim = c(0,55),
          ylim = c(0, 3.5),
          #lab = slac_results$`Gene name`,
          point_opacity = 0.5,
          tooltips = TRUE,
          tooltip_text = slac_results$`Gene name`,
          xlab = "pi_aa",
          ylab = "dN/dS")

