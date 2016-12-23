
data{
    int <lower=0> N; //number of data points
    real <lower=0> age_at_death_real[N]; //ages at death
    int <lower=0> age_at_death_int[N];
}

parameters{
    //beta dist params
    real<lower=max(age_at_death_real),upper=1000> max_lifespan;
    real<lower=0> alpha;
    real<lower=0> beta;
    
    //poisson dist params
    real<lower=0,upper=1000> lambda;
    
    //mixture params
    real<lower=0,upper=1> mix;
}

transformed parameters{
    real<lower=0> age_transformed[N];
    for (i in 1:N){
        age_transformed[i] = age_at_death_real[i]/max_lifespan;
    }
}

model{
    //priors on parameters
    
    // model of age at death
    // increment directly to ensure constants are preserved
    
    vector[2] log_ps;
    log_ps[1] = log(mix) + beta_log(age_transformed, alpha, beta);
    log_ps[2] = log(1-mix) + poisson_log(age_at_death_int, lambda);
    
    increment_log_prob(log_sum_exp(log_ps));
    
}