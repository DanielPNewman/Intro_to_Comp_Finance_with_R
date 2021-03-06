### MONTHLY STARBUCKS RETURN DATA ###

# Assign the URL to the CSV file
data_url <- ("http://assets.datacamp.com/course/compfin/sbuxPrices.csv")

# Load the data frame using read.csv
sbux_df <-read.csv(file.path(data_url), header = T, stringsAsFactors=F)


# Check the structure of 'sbux_df'
str(sbux_df)

# Check the first and last part of 'sbux_df'
head(sbux_df)
tail(sbux_df)

# Get the class of the Date column of 'sbux_df'
class(sbux_df$Date)

#make seperate closing_prices variable, but use drop=F to keep the dimension info to keep it as a data frame
closing_prices <- sbux_df[,"Adj.Close", drop=F]

# The which() function returns the indices for which a condition is TRUE. 
# For example: which(sbux_df$Date == "3/1/1994") returns the position of the date 3/1/1994, 
# which indicates in this case the row number in the sbux_df data frame.

# Find indices associated with the dates 3/1/1994 and 3/1/1995
index_1 <- which(sbux_df$Date == "3/1/1994")
index_2 <- which(sbux_df$Date == "3/1/1995")
    
# Extract prices between 3/1/1994 and 3/1/1995
some_prices <- sbux_df$Adj.Close[index_1:index_2]


# Create a new data frame that contains the price data with the dates as the row names
sbux_prices_df <- sbux_df[, "Adj.Close", drop=FALSE]
rownames(sbux_prices_df) <- sbux_df$Date
head(sbux_prices_df)

# With Dates as rownames, you can subset directly on the dates.
# Find indices associated with the dates 3/1/1994 and 3/1/1995.
price_1 <- sbux_prices_df["3/1/1994",]
price_2 <- sbux_prices_df["3/1/1995",]

# Now add all relevant arguments to the plot function below to get a nicer plot
plot(sbux_df$Adj.Close, ylab="Adjusted close",
     main="Monthly closing price of SBUX", type="l", col='blue', lwd=2)


###### Calculate simple returns #########

# Your task in this exercise is to compute the simple returns for every time point. 
# The fact that R is vectorized makes that relatively easy. 
# In case you would like to calculate the price difference over time, you can use:
#     sbux_prices_df[2:n,1] - sbux_prices_df[1:(n-1),1]
# Think about why this indeed calculates the price difference for all time periods. 
# The first vector contains all prices, except the price on the first day. 
# The second vector contains all prices except the price on the last day. 


# Denote n the number of time periods
n <- nrow(sbux_prices_df)

#Calculate the difference in closing price between each month:
sbux_diff<-sbux_prices_df[2:n,1] - sbux_prices_df[1:(n-1),1]

#calaulate the simple return from month-to-month:
sbux_ret <- sbux_diff/sbux_prices_df[1:(n-1),1]
    
# Notice that sbux_ret is not a data frame object:
class(sbux_ret)

# Now add dates as names to the vector and print the first elements of sbux_ret to the console 
sbux_ret <- setNames(sbux_ret, sbux_df$Date[2:n])
head(sbux_ret)


########### Compute continuously compounded 1-month returns  ##############

# As you might remember from class, the relation between single-period and multi-period 
# returns is multiplicative for single returns. That is not very convenient. 
# The yearly return is for example the geometric average of the monthly returns.
# Therefore, in practice you will often use continuously compounded returns. 
# These returns have an additive relationship between single and multi-period 
# returns 

# Compute continuously compounded 1-month returns
sbux_ccret <- log(sbux_prices_df[2:n,1] ) - log(sbux_prices_df[1:(n-1),1])


# Assign names to the continuously compounded 1-month returns
names(sbux_ccret) <- sbux_df$Date[2:n]
    
# Show sbux_ccret
head(sbux_ccret)

# Compare the simple and continuously compounded returns
cbind(sbux_ret, sbux_ccret)


# The simple returns (sbux_ret) and the continuously compounded returns .
# (sbux_ccret) have been preloaded in your workspace

# Plot the returns on the same graph
plot(sbux_ret, type="l", col="blue", lwd=2, ylab="Return",
     main="Monthly Returns on SBUX")

# Add horizontal line at zero
abline(h=0)

# Add a legend
legend(x="bottomright", legend=c("Simple", "CC"), 
       lty=1, lwd=2, col=c("blue","red"))

# Add the continuously compounded returns
lines(sbux_ccret,  col="red", lwd=2)


############ Calculate growth of $1 invested in SBUX ####################

# Compute gross returns (i.e. the simple return + 1)
sbux_gret <- sbux_ret + 1

# Remember that when you use simple returns, the total return over a period can be 
# obtained by taking the cumulative product of the gross returns. R has a handy 
# cumprod() function that calculates that cumulative product.
    
    # Compute future values
    sbux_fv <- cumprod(sbux_gret)
    
    # Plot the evolution of the $1 invested in SBUX as a function of time
    plot(sbux_fv, type="l", col="blue", lwd=2, ylab="Dollars", 
         main="FV of $1 invested in SBUX")










