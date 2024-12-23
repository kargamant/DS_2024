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

# simulating models by AR
ars <- c(0.9, -0.5, 0.2, -0.3)
series_ar4 <- arima.sim(n=10000, list(ar=ars))
plot(series_ar4)
acf(series_ar4)
pacf(series_ar4)

series_ar3 <- arima.sim(n=10000, list(ar=ars[1:3]))
plot(series_ar3)
acf(series_ar3)
pacf(series_ar3)

series_ar2 <- arima.sim(n=10000, list(ar=ars[1:2]))
plot(series_ar2)
acf(series_ar2)
pacf(series_ar2)

series_ar1 <- arima.sim(n=10000, list(ar=ars[1:1]))
plot(series_ar1)
acf(series_ar1)
pacf(series_ar1)

# simulating models by MA
mas <- c(-1.9, 1.7, -1.5, 1.5)
series_ma4 <- arima.sim(n=10000, list(ma=mas))
plot(series_ma4)
acf(series_ma4)
pacf(series_ma4)

series_ma3 <- arima.sim(n=10000, list(ma=mas[1:3]))
plot(series_ma3)
acf(series_ma3)
pacf(series_ma3)

series_ma2 <- arima.sim(n=10000, list(ma=mas[1:2]))
plot(series_ma2)
acf(series_ma2)
pacf(series_ma2)

series_ma1 <- arima.sim(n=10000, list(ma=mas[1:1]))
plot(series_ma1)
acf(series_ma1)
pacf(series_ma1)