library(ggplot2)
library(dplyr)
library(tidyverse)
library(rcartocolor)
library(RColorBrewer)
library(pals)
library(ggsci)
library(reshape2)
library(lubridate)
library(patchwork)

data<-read.table("top_10_greekletter_clades_AMP.tsv", header = TRUE,
                 sep= '\t', row.names = 1)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')

var<-var %>%
  filter(var$Library_prep == "AMP" & AMP_greek_letter == "Y")

rownames(var) <- var$Sample

melted<-melt(data)

for_plotting<-cbind(melted,var)

safe_pal<-carto_pal(11,"Safe")
p1<-ggplot(for_plotting, aes(x = reorder(mdy(Date.1), Days_from_4_21_20),
                             value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_fill_manual(values = safe_pal)
p2<-p1 + theme_bw()

p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "\nSampling Date", y = "Relative Abundance", fill = "WHO Clade") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = .5, color = "Black", size=8),
        axis.title = element_text(face = "bold", size = 14))
p5<-p4 + facet_wrap(~Plant, 
                    nrow = 1, 
                    scales = "free_x")
p6<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), 
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "bottom")+
  scale_y_continuous(expand = c(0.001,0.001))
AMP_plot<-p6

data<-read.table("top_10_greekletter_clades_ILR.tsv", header = TRUE,
                 sep= '\t', row.names = 1)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')

var<-var %>%
  filter(var$Library_prep == "IRV" & IRV_greek_letter == "Y")

rownames(var) <- var$Sample

melted<-melt(data)

for_plotting<-cbind(melted,var)

for_plotting<-for_plotting %>%
  filter(Plant != "NC")
safe_pal<-carto_pal(11,"Safe")
p1<-ggplot(for_plotting, aes(x = reorder(mdy(Date.1), Days_from_4_21_20),
                             value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_fill_manual(values = safe_pal)
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "\nSampling Date", y = "Relative Abundance", fill = "WHO Clade") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = 0.5, color = "Black", size=7),
        axis.title = element_text(face = "bold", size = 14))
p5<-p4 + facet_grid(~Plant, 
                    scales = "free_x", space = "free")
p6<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), 
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "bottom")+
  scale_y_continuous(expand = c(0.001,0.001))

p6
IRV_plot<-p6
pcombined<-IRV_plot/AMP_plot
pcombined+ plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(size = 16, face = "bold", color = "black"))