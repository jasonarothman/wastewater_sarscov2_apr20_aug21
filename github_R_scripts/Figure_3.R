library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggsci)
library(patchwork)

data<-read.table("tiled_amplicon_subclades_wastewater_vs_clinical.txt", header = TRUE,
                 sep= '\t')

data$Wastewater<-as_date(data$Wastewater)
data$Clinical<-as_date(data$Clinical)
data<-data%>%
  filter(Abundance > 0.0021 
         & Wastewater < Clinical)
data$Abundance<- NULL
data$Earlier_in_Wastewater<-NULL
melted<-melt(data, id.vars = "Clade")

melted$value<-as_date(melted$value)

melted$Clade <- factor(melted$Clade, levels = c(sort(unique(melted$Clade), 
                                                     decreasing = TRUE)))

p1<-ggplot(melted, aes(x = as.Date(value), y = Clade, color = as.factor(variable))) + 
  geom_line(aes(group = Clade), color = "black", size = 0.8) +
  geom_point(size = 2.5, color = "black") +
  geom_point(size = 2) +
  scale_color_igv(name = "Sublineage First Detected in:")
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.minor = element_blank(),
               panel.grid.major = element_line(color = "black",
                                               size = 0.2))
p4<-p3 + labs(x = "\nDate", y = "Sublineage", fill = "Date Detected", 
              title = "Tiled-Amplicon Samples") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = .5, 
                                   color = "Black", size=12),
        axis.text.y = element_text(size = 8),
        axis.title = element_text(face = "bold", size = 14),
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5)) +
  scale_x_date(breaks = "month")
p5<-p4 
p6amp<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), panel.border = element_blank(),
                  strip.background = element_blank(),
                  strip.text = element_text(face = "bold", size = 14),
                  legend.title = element_text(face = "bold", size = 16),
                  legend.text = element_text(face = "bold", size = 16),
                  legend.position = "none") +
  guides(color = guide_legend(override.aes = list(size = 3)))
p6amp<-p6amp + guides(color = "none")

data<-read.table("ILR_subvariants_wastewater_medical_for_plot.txt", header = TRUE,
                 sep= '\t')
data$Wastewater<-as_date(data$Wastewater)
data$Clinical<-as_date(data$Clinical)
total_un<-unique(data$Clade)
data<-data%>%
  filter(Abundance > 0.0021 & 
           Wastewater < Clinical)
data$Abundance<- NULL
data$Earlier_in_Wastewater<-NULL
melted<-melt(data, id.vars = "Clade")

melted$value<-as_date(melted$value)

melted$Clade <- factor(melted$Clade, levels = c(sort(unique(melted$Clade), 
                                                     decreasing = TRUE)))
p1<-ggplot(melted, aes(x = as.Date(value), y = Clade, color = as.factor(variable))) + 
  geom_line(aes(group = Clade), color = "black", size = 0.8) +
  geom_point(size = 2.5, color = "black") +
  geom_point(size = 2) +
  scale_color_igv(name = "Sublineage First Detected in:")
p2<-p1 + theme_bw()

p3<-p2 + theme(panel.grid.minor = element_blank(),
               panel.grid.major = element_line(color = "black",
                                               size = 0.2))
p4<-p3 + labs(x = "\nDate", y = "Sublineage", fill = "Date Detected",
              title = "IRV-Enriched Samples") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 90, h = 1, v = .5, 
                                   color = "Black", size=12),
        axis.text.y = element_text(size = 8),
        axis.title = element_text(face = "bold", size = 14),
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5)) +
  scale_x_date(breaks = "month")
p5<-p4 
p6ilr<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), panel.border = element_blank(),
                  strip.background = element_blank(),
                  strip.text = element_text(face = "bold", size = 14),
                  legend.title = element_text(face = "bold", size = 16),
                  legend.text = element_text(face = "bold", size = 16),
                  legend.position = "bottom")+
  guides(color = guide_legend(override.aes = list(size = 3)))
p6ilr<-p6ilr + guides(color = "none")


pal_igv("default")(2)
data<-read.table("wastewater_vs_clinical_barplot.txt", header = TRUE,
                 sep= '\t')

p1<-ggplot(data, aes(x = data$Library, y = data$Lineages,
                     fill = Sample.Source)) + 
  geom_bar(position = "dodge",stat = "identity") + 
  geom_bar(position = "dodge", stat = "identity", color = "black")+
  scale_fill_manual(values = c("#CE3D32FF", "#5050FFFF"), name = "Sublineage First Detected in:")+
  scale_color_manual("black")
p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3 + labs(x = "\nLibrary Preparation Method", y = "Number of Lineages First Detected In", fill = "Sample Source") +
  theme(axis.text = element_text(face = "bold", size = 10, color = "black"),
        axis.text.x = element_text(angle = 0, h = 0.5, v = .5, color = "Black",
                                   size=12),
        axis.title = element_text(face = "bold", size = 14),
        axis.title.x = element_blank())
p5<-p4 
p6<-p5 + theme(panel.spacing.x = unit(0.3, "lines"), 
               strip.background = element_blank(),
               strip.text = element_text(face = "bold", size = 14),
               legend.title = element_text(face = "bold", size = 14),
               legend.text = element_text(face = "bold", size = 12),
               legend.position = "none")+
  scale_y_continuous(expand = c(0.001,0.001), limits = c(0,1000))

barplot<-p6

((p6ilr | p6amp)|(barplot)) + plot_annotation(tag_levels = 'A')+ 
  plot_layout(guides = "collect", widths = c(4,4,1)) & 
  theme(legend.position = "bottom",
        plot.tag = element_text(size = 18, 
                                face = "bold"))