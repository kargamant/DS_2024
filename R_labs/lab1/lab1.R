to_drop <- "analysis.txt"

data <- read.delim("zipIncome.txt", header=TRUE, sep="|")

# renaming columns
colnames(data)[colnames(data) == "zip_prefixes"] <- "zipCode"
colnames(data)[colnames(data) == "meanhouseholdincome"] <- "income"

write.table(summary(data["income"]), file=to_drop, sep="")

# plot
png("plt.png")
plot(data["income"])
dev.off()

# subset
data[is.na(data)] <- 0
subs <- subset(data, data["income"]>7000 & data["income"]<200000)

write.table(summary(subs["income"]), file=to_drop, append=TRUE, sep="")

quantile(unlist(subs["income"]), probs=c(0, 0.25, 0.5, 0.75, 1))

png("boxplt.png")
boxplot(subs["income"], range=0, horizontal=TRUE)
title("boxplot", xlab="income")
dev.off()

png("boxplt_log.png")
boxplot(subs["income"], range=0, log="x", horizontal = TRUE)
title("logarithmic boxplot", xlab="income")
dev.off()

install.packages("ggplot2")

library(ggplot2)

plt <- ggplot(data, aes(unlist(data["zipCode"]), unlist(data["income"]), color=unlist(data["zipCode"])))

plt <- plt + geom_jitter() + labs(title="jitter_plot", x="zipCode", y="income", colour="zipCodes")
plt
ggsave("jitterplt.png")

plt + geom_boxplot()
ggsave("jitter_box_plt.png")

# epicycloid
r <- 5
k <- 4
angles <- sapply(1:360, function(d) d*pi/180)
x_vec <- sapply(angles, function(rad) r*(k+1)*cos(rad) - r*cos((k+1)*rad))
y_vec <- sapply(angles, function(rad) r*(k+1)*sin(rad) - r*sin((k+1)*rad))
cycloid_df <- data.frame(x=x_vec, y=y_vec)

epicycloid <- ggplot(cycloid_df, aes(x_vec, y_vec))
epicycloid + geom_point()

data["zipCode"] <- as.factor(unlist(data["zipCode"]))
summary(data)
