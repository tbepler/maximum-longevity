
data{
    int <lower=0> N; //number of data points
    real <lower=0> age_at_death[N]; //ages at death
}

parameters{
    real<lower=max(age_at_death)> max_lifespan;
    real<lower=0> alpha;
    real<lower=0> beta;
}

transformed parameters{
    real<lower=0> age_transformed[N];
    for (i in 1:N){
        age_transformed[i] = age_at_death[i]/max_lifespan;
    }
}

model{
    //priors on parameters
    max_lifespan ~ exponential(1./15.); // give the prior a mean of 15 (125 because relative to 110)
    alpha ~ lognormal(0, 10);
    beta ~ lognormal(0, 10);
    
    // model of age at death
    // increment directly to ensure constants are preserved
    age_transformed ~ beta(alpha, beta);
}