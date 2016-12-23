
data{
    int <lower=0> N; //number of data points
    int <lower=0> age_at_death[N]; //ages at death
}

parameters{
    real<lower=0> lambda;
}

model{
    //priors on parameters
    
    // model of age at death
    age_at_death ~ poisson(lambda);
}