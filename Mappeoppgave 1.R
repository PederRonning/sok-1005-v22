library(tidyverse)
library(data.table)
library(zoo)
library(reshape2)

Lower <- fread("https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt")

Lower1 = subset(Lower, select = c(Year,Globe,Mo))
Lower1 <- Lower1 [-c(1)]
Lower1 <- head(Lower1, -1)
Lower1$Globe <- as.numeric(as.character(Lower1$Globe))
Lower1$Year <- as.numeric(as.character(Lower1$Year))
Lower1$Mo <- as.numeric(as.character(Lower1$Mo))

Lower1$Ymo <- paste(Lower1$Year,Lower1$Mo)
Lower1$Ymo <- as.yearmon(paste(Lower1$Year,Lower1$Mo), "%Y %m")


Lower1 %>%
  ggplot(aes(x=Ymo, y=Globe)) +
  geom_point(col="dark blue") + geom_line(col="blue", group = 1) + 
  geom_line(col="red", size = 1.25, aes(y=rollmean(Lower1$Globe, 13, na.pad=TRUE))) +
  scale_x_yearmon(labels = Lower1$Year, breaks = Lower1$Year, expand = c(0, 0), limits = c(1979, NA)) +
  scale_y_continuous(labels = scales::comma_format(accuracy = 0.1), limits = c(-0.7, 0.9), breaks = seq(-0.7, 0.9, by = 0.1)) +
  labs(title="Latest Global Temps",
       x ="Latest Global Average Tropospheric Temperatures",
       y = "T Departure from '91-'20 Avg. (deg. C)") +
  theme(axis.text.x = element_text(angle = 90))



Lower2 = subset(Lower, select = c(Year,Mo,NoPol))
Lower2 <- head(Lower2, -1)
MidTroposphere <- fread("http://vortex.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt")
MidTroposphere <- head(MidTroposphere, -1)
MidTroposphere <- subset(MidTroposphere, select = c(Year,Mo,NoPol))
Tropopause <- fread("http://vortex.nsstc.uah.edu/data/msu/v6.0/ttp/uahncdc_tp_6.0.txt")
Tropopause <- head(Tropopause, -1)
Tropopause <- subset(Tropopause, select = c(Year,Mo,NoPol))
LowerStratosphere <- fread("http://vortex.nsstc.uah.edu/data/msu/v6.0/tls/uahncdc_ls_6.0.txt")
LowerStratosphere <- subset(LowerStratosphere, select = c(Year,Mo,NoPol))

names(MidTroposphere)[names(MidTroposphere) == 'NoPol'] <- 'NoPol2'
names(LowerStratosphere)[names(LowerStratosphere) == 'NoPol'] <- 'NoPol4'
names(Tropopause)[names(Tropopause) == 'NoPol'] <- 'NoPol3'

NoPoldata <- rbind(Lower2, MidTroposphere, Tropopause, LowerStratosphere, fill = TRUE)
NoPoldata$Year <- as.numeric(as.character(NoPoldata$Year))
NoPoldata$Mo <- as.numeric(as.character(NoPoldata$Mo))

NoPoldata <- rbind(Lower2, MidTroposphere, Tropopause, LowerStratosphere, fill = TRUE)
NoPoldata$Ymo2 <- as.yearmon(paste(NoPoldata$Year,NoPoldata$Mo), "%Y %m")
NoPoldata$NoPol <- as.numeric(as.character(NoPoldata$NoPol))
NoPoldata$NoPol2 <- as.numeric(as.character(NoPoldata$NoPol2))
NoPoldata$NoPol3 <- as.numeric(as.character(NoPoldata$NoPol3))
NoPoldata$NoPol4 <- as.numeric(as.character(NoPoldata$NoPol4))

NoPoldata <- data.frame(index=c(NoPoldata$Ymo2),
                 NedreTroposfaere=c(NoPoldata$NoPol),
                 MidtreTropospaere=c(NoPoldata$NoPol2),
                 Tropopause=c(NoPoldata$NoPol3),
                 NedreStratosfaere=c(NoPoldata$NoPol4))

NoPoldata <- melt(NoPoldata ,  id.vars = 'index', variable.name = 'Level')

NoPoldata <- NoPoldata[complete.cases(NoPoldata), ]

ggplot(NoPoldata, aes(index, value)) +
  geom_point(aes(colour = Level)) +
  geom_line(col ="red", size = 1.25, aes(y=rollmean(value, 13, na.pad=TRUE))) +
  scale_x_yearmon(labels = Lower1$Year, breaks = Lower1$Year, expand = c(0, 0), limits = c(1979, NA)) +
  labs(title="Temperaturdata",
       x =" ",
       y = "Gjennomsnittlig Temperatur (C)") +
  theme(axis.text.x = element_text(angle = 90))


