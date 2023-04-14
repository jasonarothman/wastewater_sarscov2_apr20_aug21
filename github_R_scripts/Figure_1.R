library(ggplot2)
library(dplyr)
library(tidyverse)
library(rcartocolor)
library(RColorBrewer)
library(pals)
library(ggsci)
library(lubridate)
library(patchwork)
library(reshape2)
data<-read.table("all_ILR_samples_combined_bracken_viruses.txt", sep = '\t', quote = "", 
                 header = TRUE, row.names = 1)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')

var<-var %>%
  filter(Library_prep == "IRV")
rownames(var)<-var$Sample
data<- data[complete.cases(data), ]

column_sums <- colSums(data)
data_norm <- apply(data, 1, '/', column_sums)

data_norm<-t(data_norm)
data_norm<-as.data.frame(data_norm)
data_norm$mean<-rowMeans(data_norm)
data_norm <-data_norm %>%
  rownames_to_column("Sample") %>%
  filter(data_norm$mean > 0.00000001) %>%
  top_n(10) %>%
  subset(., select = -c(mean))

data_norm = setNames(data.frame(t(data_norm[,-1])),data_norm[,1])

#write.table(datanorm, "top_10_ILR_viruses_relative_abundance.txt", sep = '\t')

data<-read.table("top_10_ILR_viruses_relative_abundance.txt", header = TRUE, row.names = 1,
                 sep= '\t', check.names = FALSE)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')
var<-var %>%
  filter(Library_prep == "IRV")
rownames(var)<-var$Sample

melted<-melt(data)
for_plotting<-cbind(melted,var)

safe_pal<-carto_pal(11,"Safe")
p1<-ggplot(for_plotting, aes(x = reorder(mdy(Date.1),Days_from_4_21_20), value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_fill_manual(values = safe_pal)
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "Sampling Date", y = "Relative Abundance", fill = "Virus") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = .5, color = "Black", size=6),
        axis.title = element_text(face = "bold", size = 14),
        axis.title.x = element_blank())
p5<-p4 + facet_grid(~Plant, 
                    scales = "free_x", space = "free")
p6<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), panel.border = element_blank(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "bottom") +
  scale_y_continuous(expand = c(0.001,0.001))
p6
IRV_plot<-p6

data<-read.table("all_sarscov2_amplicon_samples_virus_bracken_counts.txt", sep = '\t', quote = "", 
                 header = TRUE, row.names = 1)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')

var<-var %>%
  filter(Library_prep == "AMP")
rownames(var)<-var$Sample
data<- data[complete.cases(data), ]

column_sums <- colSums(data)
data_norm <- apply(data, 1, '/', column_sums)

data_norm<-t(data_norm)
data_norm<-as.data.frame(data_norm)
data_norm$mean<-rowMeans(data_norm)
data_norm <-data_norm %>%
  rownames_to_column("Sample") %>%
  filter(data_norm$mean > 0.00000001) %>%
  top_n(10) %>%
  subset(., select = -c(mean))

data_norm = setNames(data.frame(t(data_norm[,-1])),data_norm[,1])

#write.table(data_norm,"top_10_AMP_viruses_relative_abundance.txt", sep = '\t')


data<-read.table("top_10_AMP_viruses_relative_abundance.txt", header = TRUE, row.names = 1,
                 sep= '\t', check.names = FALSE)

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')
var<-var %>%
  filter(Library_prep == "AMP")
rownames(var)<-var$Sample

melted<-melt(data)
for_plotting<-cbind(melted,var)

safe_pal<-carto_pal(11,"Safe")

p1<-ggplot(for_plotting, aes(x = reorder(mdy(Date.1),Days_from_4_21_20), value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_fill_manual(values = c("#88CCEE","#888888"))

p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "\nSampling Date", y = "Relative Abundance", fill = "Virus") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = .5, color = "Black", size=8),
        axis.title = element_text(face = "bold", size = 14))
p5<-p4 + facet_grid(~Plant, 
                    scales = "free_x", space = "free")
p6<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), panel.border = element_blank(),
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "bottom")+
  scale_y_continuous(expand = c(0.001,0.001))
p6
AMP_plot<-p6

pcombined<-(IRV_plot/AMP_plot)
pcombined + plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(size = 16, face = "bold", color = "black"))
