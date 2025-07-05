-- =====================================================
-- ENHANCED CORPORATE SQL SOLUTIONS
-- Real-world complexity matching 3+ years analyst experience
-- Includes performance optimization and advanced techniques
-- =====================================================

-- =====================================================
-- VERSION 1 ENHANCED: Crisis Analytics with Performance Focus
-- =====================================================

-- CHALLENGE 1: Real-time Portfolio Dashboard (Performance Critical)
-- Business Context: CEO needs live dashboard updating every 5 minutes
-- Corporate Reality: Query must run on 150K+ loans in <30 seconds

-- Sample Table 
SELECT * FROM sample_customers;
SELECT * FROM sample_defaults;
SELECT * FROM sample_institutions;
SELECT * FROM sample_loans;
SELECT * FROM sample_payments;

-- SOLUTION 1A: Basic Approach (Too Slow for Production)
SELECT 
    loan_status,
    COUNT(*) as loan_count,
    SUM(loan_amount) as total_exposure,
    AVG(loan_amount) as avg_loan_size,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as portfolio_percentage
FROM sample_loans
GROUP BY loan_status
ORDER BY total_exposure DESC;

-- SOLUTION 1B: Optimized Corporate Version
WITH portfolio_metrics AS (
    SELECT 
        loan_status,
        COUNT(*) as loan_count,
        SUM(loan_amount) as total_exposure,
        AVG(loan_amount) as avg_loan_size,
        -- Pre-calculate running totals for performance
        SUM(SUM(loan_amount)) OVER() as total_portfolio_value,
        COUNT(COUNT(*)) OVER() as total_loan_count
    FROM sample_loans l
    -- Performance optimization: Only active data
    WHERE l.disbursement_date >= DATEADD(year, -5, GETDATE())
    GROUP BY loan_status
),
risk_indicators AS (
    SELECT 
        loan_status,
        CASE 
            WHEN loan_status = 'Defaulted' THEN 'CRITICAL'
            WHEN loan_status = 'Active' AND total_exposure > 100000000 THEN 'HIGH_WATCH'
            ELSE 'NORMAL'
        END as risk_flag
    FROM portfolio_metrics
)
SELECT 
    pm.loan_status,
    FORMAT(pm.loan_count, '#,##0') as loan_count,
    FORMAT(pm.total_exposure, 'C0') as total_exposure,
    FORMAT(pm.avg_loan_size, 'C0') as avg_loan_size,
    ROUND(pm.loan_count * 100.0 / pm.total_loan_count, 2) as portfolio_percentage,
    ROUND(pm.total_exposure * 100.0 / pm.total_portfolio_value, 2) as exposure_percentage,
    ri.risk_flag,
    -- Executive KPI: Change from last month
    LAG(pm.total_exposure) OVER (ORDER BY pm.loan_status) as prev_month_exposure,
    ROUND(
        (pm.total_exposure - LAG(pm.total_exposure) OVER (ORDER BY pm.loan_status)) 
        * 100.0 / NULLIF(LAG(pm.total_exposure) OVER (ORDER BY pm.loan_status), 0), 2
    ) as month_over_month_change
FROM portfolio_metrics pm
INNER JOIN risk_indicators ri ON pm.loan_status = ri.loan_status
ORDER BY pm.total_exposure DESC;


-- =====================================================
-- CHALLENGE 2: Advanced Customer Segmentation with ML-Ready Features
-- Business Context: Risk team needs features for ML model training
-- Corporate Reality: Must handle 100K+ customers with complex business logic
-- =====================================================

WITH customer_behavior_features AS (
    SELECT 
        c.customer_id,
        c.current_city,
        c.annual_income,
        c.cibil_score,
        
        -- Loan portfolio features
        COUNT(l.loan_id) as total_loans,
        SUM(l.loan_amount) as total_borrowed,
        AVG(l.loan_amount) as avg_loan_size,
        MAX(l.loan_amount) as max_loan_amount,
        
        -- Time-based features
        DATEDIFF(MONTH, MIN(l.disbursement_date), MAX(l.disbursement_date)) as customer_tenure_months,
        DATEDIFF(MONTH, MAX(l.disbursement_date), GETDATE()) as months_since_last_loan,
        
        -- Payment behavior features (complex aggregation)
        COUNT(p.payment_id) as total_payments_made,
        AVG(CAST(p.days_early_late AS FLOAT)) as avg_payment_delay,
        STDEV(CAST(p.days_early_late AS FLOAT)) as payment_consistency_score,
        
        -- Advanced behavioral metrics
        SUM(CASE WHEN p.days_early_late > 30 THEN 1 ELSE 0 END) as severe_delays_count,
        SUM(CASE WHEN p.payment_status = 'Failed' THEN 1 ELSE 0 END) as failed_payments_count,
        
        -- Financial health indicators
        CASE 
            WHEN c.annual_income > 0 THEN SUM(l.emi_amount * 12) / c.annual_income 
            ELSE 1 
        END as debt_to_income_ratio 
                
        
    FROM sample_customers c
    LEFT JOIN sample_loans l ON c.customer_id = l.customer_id
    LEFT JOIN sample_payments p ON l.loan_id = p.loan_id
    WHERE c.registration_date >= DATEADD(year, -3, GETDATE())  -- Recent customers only
    GROUP BY c.customer_id, c.current_city, c.annual_income, c.cibil_score
),
risk_scoring AS (
    SELECT *,
        -- Composite risk score (0-100)
        CASE 
            WHEN cibil_score >= 750 AND avg_payment_delay <= 5 AND debt_to_income_ratio <= 0.3 THEN 
                GREATEST(90, LEAST(100, 95 - (severe_delays_count * 2)))
            WHEN cibil_score >= 650 AND avg_payment_delay <= 15 AND debt_to_income_ratio <= 0.5 THEN 
                GREATEST(70, LEAST(89, 80 - (severe_delays_count * 3)))
            WHEN cibil_score >= 550 AND debt_to_income_ratio <= 0.7 THEN 
                GREATEST(50, LEAST(69, 60 - (severe_delays_count * 4)))
            ELSE 
                GREATEST(10, LEAST(49, 40 - (severe_delays_count * 5)))
        END as composite_risk_score,
        
        -- Customer value score (for prioritization)
        CASE 
            WHEN total_borrowed >= 1000000 AND customer_tenure_months >= 24 THEN 'High Value'
            WHEN total_borrowed >= 500000 AND customer_tenure_months >= 12 THEN 'Medium Value'
            WHEN total_borrowed >= 200000 THEN 'Standard Value'
            ELSE 'Low Value'
        END as customer_value_segment,
        
        -- Churn risk indicator
        CASE 
            WHEN months_since_last_loan > 24 AND total_loans = 1 THEN 'High Churn Risk'
            WHEN months_since_last_loan > 12 THEN 'Medium Churn Risk'
            ELSE 'Active Customer'
        END as churn_risk_flag
        
    FROM customer_behavior_features
)
SELECT 
    customer_value_segment,
    churn_risk_flag,
    COUNT(*) as customer_count,
    AVG(composite_risk_score) as avg_risk_score,
    AVG(total_borrowed) as avg_lifetime_value,
    AVG(debt_to_income_ratio) as avg_debt_ratio,
    
    -- Business action recommendations
    CASE 
        WHEN AVG(composite_risk_score) >= 80 AND customer_value_segment = 'High Value' 
        THEN 'RETAIN: Offer premium products and exclusive benefits'
        WHEN AVG(composite_risk_score) >= 60 AND customer_value_segment IN ('High Value', 'Medium Value')
        THEN 'NURTURE: Targeted offers and relationship management'
        WHEN AVG(composite_risk_score) <= 40 
        THEN 'RESTRICT: Tighten credit policies and increase monitoring'
        ELSE 'STANDARD: Continue current approach'
    END as recommended_strategy,
    
    -- Economic impact calculation
    SUM(total_borrowed) as segment_total_exposure,
    SUM(total_borrowed * (1 - composite_risk_score/100)) as estimated_risk_adjusted_value
    
FROM risk_scoring
GROUP BY customer_value_segment, churn_risk_flag
ORDER BY segment_total_exposure DESC;
