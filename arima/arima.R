data <- read.csv("jj.dat", header = FALSE)
names(data) <- c("EPS")

series <- ts(data[["EPS"]], frequency=4, start=c(1960, 1))
series
plot(series)
axis(1, 1960:1980)

plot(diff(series))
axis(1, 1960:1980)

log_series <- ts(log(data[["EPS"]]), frequency=4, start=c(1960,1))
plot(log_series)

plot(diff(log_series))
