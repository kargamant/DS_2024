data <- read.csv("jj.dat", header = FALSE)
names(data) <- c("EPS")

series <- ts(data[["EPS"]], frequency=4, start=c(1960, 1))
series
plot(series)
axis(1, 1960:1980)

plot(diff(series, differences=1))
axis(1, 1960:1980)

log_series <- ts(log(data[["EPS"]]), frequency=4, start=c(1960,1))
plot(log_series)

stationary <- diff(log_series, differences=1) 
plot(stationary)

# non differenced
acf(series, 83)
axis(1, 1:83)
pacf(series, 83)
axis(1, 1:83)

acf(stationary, 83)
axis(1, 1:83)
pacf(stationary, 83)
axis(1, 1:83)



# I'd say that AR(1), I(1), MA(5)
model <- arima(stationary, order=c(1,1,5))
model["aic"]

# looking for the lowest aic
p <- 1
d <- 1
q <- c(1:10)
stationary <- diff(log_series, differences=d) 

aics <- sapply(q, function(x) arima(stationary, order=c(p,d,x))["aic"])
aics


