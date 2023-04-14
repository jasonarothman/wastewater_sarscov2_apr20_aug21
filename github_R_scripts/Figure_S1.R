library("ggplot2")
library("patchwork")

depth<-read.table("all_bams_merged_ILR_depth.txt", header = TRUE,sep = '\t')
p1<-ggplot(depth, aes(x = Position, y = (Depth/269)))+
  geom_area(fill = "black")
p2<- p1 + theme_bw()
p3<-p2 + theme(
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank())
p4<-p3 + xlab("Genomic Position") + ylab("Average Reads Per Base")  +
  theme(axis.title.x = element_text(face = "bold", size = 14), 
        axis.title.y = element_text(face = "bold", size = 14), 
        legend.title  = element_text(face = "bold"), 
        axis.text.x = element_text(face = "bold", size = 12, color = "black",
                                   angle = 90, h = 0.5, v = 0.5),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"))+
  scale_y_continuous(n.breaks = 10, limits = c(0,6),expand = c(0.001,0.001)) +
  scale_x_continuous(
    limits = c(0,30000), breaks = scales::pretty_breaks(n=100),expand = c(0.0001,0.0001)) 
IRV<-p4

depth<-read.table("all_bams_merged_amplicon_depth.txt", header = TRUE,sep = '\t')
p1<-ggplot(depth, aes(x = Position, y = (Depth/95)))+
  geom_area(fill = "black")
p2<- p1 + theme_bw()
p3<-p2 + theme(
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank())
p4<-p3 + xlab("Genomic Position") + ylab("Average Reads Per Base")  +
  theme(axis.title.x = element_text(face = "bold", size = 14), 
        axis.title.y = element_text(face = "bold", size = 14), 
        legend.title  = element_text(face = "bold"), 
        axis.text.x = element_text(face = "bold", size = 12, color = "black",
                                   angle = 90, h = 0.5, v = 0.5),
        axis.text.y = element_text(face = "bold", size = 12, color = "black"))+
  scale_y_continuous(n.breaks = 10, limits = c(0,6000),expand = c(0.001,0.001)) +
  scale_x_continuous(
    limits = c(0,30000), breaks = scales::pretty_breaks(n=100),expand = c(0.0001,0.0001))
AMP<-p4

pcombined<-(IRV|AMP)
pcombined + plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(size = 16, face = "bold", color = "black"))