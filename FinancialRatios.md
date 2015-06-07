**_Note: This feature is part of xbrlware Enterprise Edition._**

This guide provides information on:


## Introduction ##
xbrlware supports computation of more than 30 fundamental financial ratios out of the box for US SEC XBRL filings. These ratios are organized into six main categories. **Its also easy to extend this plugin to include new set of ratios that are proprietary or financial ratios for any XBRL filings**. _You could email us at support@xbrlware.com with subject "xbrlware ratios" to include any new ratios in xbrlware that are currently not available but widely used._

## Ratios ##
### Liquidity ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.current_ratio}" # Prints current ratio

    puts "#{ratios.quick_ratio}"

    puts "#{ratios.cash_ratio}"

    puts "#{ratios.days_inventory_outstanding}"
    puts "#{ratios.dio}" # Alias for days_inventory_outstanding

    puts "#{ratios.days_sales_outstanding}"
    puts "#{ratios.dso}" # Alias for days_sales_outstanding

    puts "#{ratios.days_payable_outstanding}"
    puts "#{ratios.dpo}" # Alias for days_payable_outstanding

    puts "#{ratios.cash_conversion_cycle}"

    lratios = ratios.liquidity # All liquidity ratios as Hash
    lratios.each do |r, v|
        puts "#{r} is #{v}"
    end    
```

### Profitability ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.gross_profit_margin}"

    puts "#{ratios.operating_profit_margin}"

    puts "#{ratios.pretax_profit_margin}"

    puts "#{ratios.net_profit_margin}"

    puts "#{ratios.effective_tax_rate}"

    puts "#{ratios.return_on_assets}"

    puts "#{ratios.return_on_equity}"

    puts "#{ratios.return_on_capital}"

    pratios = ratios.profitability # All profitability ratios as Hash
    pratios.each do |r, v|
        puts "#{r} is #{v}"
    end
```

### Debt ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.debt_ratio}"

    puts "#{ratios.debt_equity_ratio}"

    puts "#{ratios.capitalization_ratio}"

    puts "#{ratios.interest_coverage_ratio}"

    puts "#{ratios.cashflow_to_debt_ratio}"

    dratios = ratios.debt # All debt ratios as Hash
    dratios.each do |r, v|
        puts "#{r} is #{v}"
    end

```

### Operating performance ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.fixed_asset_turnover}"

    puts "#{ratios.sales_per_employee}"
    puts "#{ratios.revenue_per_employee}" # Alias for sales_per_employee

    oratios = ratios.operating_performance # All operating performance ratios as Hash
    oratios.each do |r, v|
        puts "#{r} is #{v}"
    end

```

### Cashflow indicator ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.cashflow_to_sales_ratio}"
    puts "#{ratios.cashflow_to_revenue_ratio}" # Alias to cashflow_to_sales_ratio

    puts "#{ratios.free_to_operating_cashflow}"

    puts "#{ratios.short_debt_coverage}"

    puts "#{ratios.capital_expenditure_coverage}"
    puts "#{ratios.capex_coverage}" # Alias to capital_expenditure_coverage

    puts "#{ratios.dividend_coverage}"

    puts "#{ratios.capital_expenditure_and_dividend_coverage}"
    puts "#{ratios.capex_and_dividend_coverage}" # Alias to capital_expenditure_and_dividend_coverage

    puts "#{ratios.dividend_payout_ratio}"

    cratios = ratios.cashflow_indicator # All cashflow indicator ratios as Hash
    cratios.each do |r, v|
        puts "#{r} is #{v}"
    end
    
```

### Investment valuation ratios ###
```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    puts "#{ratios.book_value_per_share}"
    puts "#{ratios.shareholders_equity_per_share}" # Alias to book_value_per_share

    puts "#{ratios.operating_cashflow_per_share}"

    iratios = ratios.investment_valuation # All investment ratios as Hash
    iratios.each do |r, v|
        puts "#{r} is #{v}"
    end
```

### Getting all Ratios ###

```
    require 'xbrlware'
    require 'analysis/fundamental/ratios'

    ins = Xbrlware.ins(<<instance_file>>)
    ratios = Analysis::Fundamental::Ratios.new(ins)

    all_ratios = ratios.all
    all_ratios.each do |category, ratio_hash|
    puts "#{category}"
        ratio_hash.each do |name, value|
            puts "\t #{name} is #{value}"
        end
    end
```