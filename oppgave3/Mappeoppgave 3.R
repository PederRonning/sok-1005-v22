library(tidyverse)
library(rvest)
library(proto)

df <- read_html("https://www.motor.no/aktuelt/motors-store-vintertest-av-rekkevidde-pa-elbiler/217132")

df <- df %>% html_table()

df <- df[[1]]

df <- df %>% 
  rename(Modell = X1,
         WLTP = X2,
         STOPP = X3,
         Avvik = X4)

df = select(df, -c(1, 4))

df =df[-1,]

df <-df[!grepl("x",df$STOPP),]

df$STOPP<-gsub("km","",as.character(df$STOPP))

df$STOPP <- as.numeric(as.character(df$STOPP))

df$WLTP <- sub("^(\\d{3}).*$", "\\1",df$WLTP)

# kilde: https://stackoverflow.com/questions/21675379/r-only-keep-the-3-x-first-characters-in-a-all-rows-in-a-column/21675473

df$WLTP <- as.numeric(as.character(df$WLTP))

df %>%
  ggplot(aes(x=WLTP, y=STOPP)) +
  geom_point(size = 2, col="black") +
  geom_abline(size = 1.2, col = "red") +
  scale_x_continuous(limits= c(200, 600), breaks = seq(200, 600, by = 100)) +
  scale_y_continuous(limits= c(200, 600), breaks = seq(200, 600, by = 100)) +
  labs(title="Stopp og WLTP, sammenlignet med 'egenting' kjørelengde",
       x ="WLTP",
       y = "STOPP") +
  theme_bw()

lm(STOPP ~ WLTP, data =df)

df %>%
  ggplot(aes(x=WLTP, y=STOPP)) +
  geom_point(size = 2, col="black") +
  geom_abline(size = 1.2, col = "red") +
  geom_smooth(method = lm) +
  scale_x_continuous(limits= c(200, 600), breaks = seq(200, 600, by = 100)) +
  scale_y_continuous(limits= c(200, 600), breaks = seq(200, 600, by = 100)) +
  labs(title="Stopp og WLTP, sammenlignet med 'egenting' kjørelengde",
       x ="WLTP",
       y = "STOPP") +
  theme_bw()