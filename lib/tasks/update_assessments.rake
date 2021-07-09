namespace :update_assessments do

  desc "Update titles of assessments and their inner elements"

  task update_risk_levels_1: :environment do
    ip_risk_stage_2 = Stage.where(title: "Basic tests showing potential").first
    ip_risk_stage_2.update(title: "POC - proof of concept")

    ip_risk_stage_3 = Stage.where(title: "Prototype developed").first
    ip_risk_stage_3.update(title: "1st line Alpha prototype developed")

    ip_risk_stage_4 = Stage.where(title: "Beta testing").first
    ip_risk_stage_4.update(title: "Production Intent Beta Type Developed")

    ip_risk_stage_5 = Stage.where(title: "Sales to paying customers").first
    ip_risk_stage_5.update(title: "In production with customer sales")

    puts "IP Risk sub_category is updated"
  end

  task update_risk_levels_2: :environment do
    # IP Advantage/Value sub_category
    ip_adv_val_stage_2 = Stage.where(title: "Limited advantage and difficult to defend").first
    ip_adv_val_stage_2.update(title: "Limited Advantage and may be difficult to defend")

    ip_adv_val_stage_3 = Stage.where(title: "Proprietary know how/trade secrets").first
    ip_adv_val_stage_3.update(title: "IP filed for, not yet issued")

    ip_adv_val_stage_4 = Stage.where(title: "Some valuable and defensible IP").first
    ip_adv_val_stage_4.update(title: "Some valuable, defensible issued IP")

    ip_adv_val_stage_5 = Stage.where(title: "Significant and highly defensible IP").first
    ip_adv_val_stage_5.update(title: "Significant, highly defensible and issued IP")

    puts "IP Advantage/Value sub_category is updated"
  end

  task update_risk_levels_3: :environment do
    prod_dev_sub_category = SubCategory.where(title: "Product Development Ownership:").first
    prod_dev_sub_category.update(title: "IP Development Ownership")

    puts "Product Development Ownership sub_category is updated"
  end

  task update_risk_levels_4: :environment do
    # Competitive Technologies: sub_category
    comp_tech_stage_1 = Stage.where(title: "Significant direct, indirect, and potential competing technologies").first
    comp_tech_stage_1.update(title: "Competitive technologies Unknown")

    comp_tech_stage_2 = Stage.where(title: "Limited direct and significant").first
    comp_tech_stage_2.update(title: "Some knowledge, no formal IP research conducted")

    comp_tech_stage_3 = Stage.where(title: "Indirect competing technologies").first
    comp_tech_stage_3.update(title: "Informal IP research conducted")

    comp_tech_stage_4 = Stage.where(title: "Limited direct, but strong potential competitive technologies").first
    comp_tech_stage_4.update(title: "Formal IP research conducted of competing technologies")

    comp_tech_stage_5 = Stage.where(title: "Limited direct and indirect competing technologies").first
    comp_tech_stage_5.update(title: "Complete thorough IP research conducted internally")

    comp_tech_stage_6 = Stage.where(title: "No direct and limited indirect competing technologies").first
    comp_tech_stage_6.update(title: "Comprehensive IP search conducted and validated by 3rd party (patent attorney)")

    puts "Competitive Technologies sub_category is updated"
  end

  task update_risk_levels_5: :environment do
    mark_risk_sub_categories = Category.where(title: "Market Risk").first.sub_categories

    mark_risk_sub_categories.where(title: 'Market Size').first.update(title: 'Competitive Landscape')
    mark_risk_sub_categories.where(title: 'Customer Segment').first.update(title: 'Market Size')
    mark_risk_sub_categories.where(title: 'Marketing/Sales Strategy').first.update(title: 'Customer Segment')
    mark_risk_sub_categories.where(title: 'Competition (Direct & Indirect)').first.update(title: 'Marketing/Sales Strategy')

    puts "Market Risk category is changed direct line"
  end

  task update_risk_levels_6: :environment do
    # Market Risk category stages updates

    mark_risk_sub_category_1 = SubCategory.where(title: 'Competitive Landscape').first.stages

    mark_risk_stage_1 = mark_risk_sub_category_1.where(title: 'No Market').first
    mark_risk_stage_1.update(title: "Limited to no understanding of competitive landscape")

    mark_risk_stage_2 = mark_risk_sub_category_1.where(title: 'Stagnating or diminishing market').first
    mark_risk_stage_2.update(title: "Some knowledge, no formal research conducted")

    mark_risk_stage_3 = mark_risk_sub_category_1.where(title: 'Very small market').first
    mark_risk_stage_3.update(title: "Informal research conducted to valid competitive landscape")

    mark_risk_stage_4 = mark_risk_sub_category_1.where(title: 'Small market').first
    mark_risk_stage_4.update(title: "Formal research conducted to understand competitive landscape")

    mark_risk_stage_5 = mark_risk_sub_category_1.where(title: 'Moderate growing market').first
    mark_risk_stage_5.update(title: "Complete thorough research/analysis conducted of both direct and indirect")

    mark_risk_stage_6 = mark_risk_sub_category_1.where(title: 'Large growing market').first
    mark_risk_stage_6.update(title: "Comprehensive search conducted & indirect/direct validated by by 3rd party sources")

    puts "Competitive Landscape sub_category is updated"
  end

  task update_risk_levels_7: :environment do
    mark_risk_sub_category_2 = SubCategory.where(title: 'Value to Customer:').first.stages

    mark_risk_stage_1_cat_2 = mark_risk_sub_category_2.where(title: 'Unknown').first
    mark_risk_stage_1_cat_2.update(title: "Unclear, no formal customer discovery")

    mark_risk_stage_2_cat_2 = mark_risk_sub_category_2.where(title: 'Unclear or low').first
    mark_risk_stage_2_cat_2.update(title: "Limited customer discovery to determine value")

    mark_risk_stage_3_cat_2 = mark_risk_sub_category_2.where(title: 'Recognizable but low value').first
    mark_risk_stage_3_cat_2.update(title: "Some customer discovery &amp; better understand of value")

    mark_risk_stage_4_cat_2 = mark_risk_sub_category_2.where(title: 'Value clear but not quantifiable').first
    mark_risk_stage_4_cat_2.update(title: "Significant customer discovery, value clear, not quantifiable")

    mark_risk_stage_5_cat_2 = mark_risk_sub_category_2.where(title: 'Value clear, somewhat moderate').first
    mark_risk_stage_5_cat_2.update(title: "Significant customer discovery, value quantifiable of your technology solution")

    mark_risk_stage_6_cat_2 = mark_risk_sub_category_2.where(title: 'Clear, quantifiable, high ROI').first
    mark_risk_stage_6_cat_2.update(title: "Value Proposition Quantifiable and validated by the customers")

    puts "Value to Customer sub_category is updated"
  end

  task update_risk_levels_8: :environment do
    # Market Size sub_category stages updates

    mark_risk_sub_category_3 = SubCategory.where(title: 'Market Size').first.stages

    mark_risk_stage_1_cat_3 = mark_risk_sub_category_3.where(title: 'Target group not defined').first
    mark_risk_stage_1_cat_3.update(title: "No Understanding of Market Potential")

    mark_risk_stage_2_cat_3 = mark_risk_sub_category_3.where(title: 'Target group vaguely or too broadly defined').first
    mark_risk_stage_2_cat_3.update(title: "Limited Understanding of Market Potential")

    mark_risk_stage_3_cat_3 = mark_risk_sub_category_3.where(title: 'Target group defined but difficult to recognize or approach').first
    mark_risk_stage_3_cat_3.update(title: "High level of research conducted to determine market size")

    mark_risk_stage_4_cat_3 = mark_risk_sub_category_3.where(title: 'Target group defined but no market segmentation').first
    mark_risk_stage_4_cat_3.update(title: "Some understanding of addressable market and early adopting market")

    mark_risk_stage_5_cat_3 = mark_risk_sub_category_3.where(title: 'Target group defined and market segmented').first
    mark_risk_stage_5_cat_3.update(title: "Validation based of market size determined based on data sources")

    puts "Market Size sub_category is updated"
  end

  task update_risk_levels_9: :environment do
    # Customer Segment sub_category stages updates

    mark_risk_sub_category_4 = SubCategory.where(title: 'Customer Segment').first.stages

    mark_risk_stage_1_cat_4 = mark_risk_sub_category_4.where(title: 'No Strategy').first
    mark_risk_stage_1_cat_4.update(title: "Target group not defined")

    mark_risk_stage_2_cat_4 = mark_risk_sub_category_4.where(title: 'Tactical ideas but holistic strategy unclear').first
    mark_risk_stage_2_cat_4.update(title: "Target group vaguely or too broadly defined")

    mark_risk_stage_3_cat_4 = mark_risk_sub_category_4.where(title: 'Outline / strategy identifiable but clear gaps exist').first
    mark_risk_stage_3_cat_4.update(title: "Target group defined but customers difficult to recognize or approach")

    mark_risk_stage_4_cat_4 = mark_risk_sub_category_4.where(title: 'Strategy clearly recognizable with only modest gaps').first
    mark_risk_stage_4_cat_4.update(title: "Target group defined but no market segmentation")

    mark_risk_stage_5_cat_4 = mark_risk_sub_category_4.where(title: 'Generally clear, consistent and complete strategy').first
    mark_risk_stage_5_cat_4.update(title: "Target group defined and market segmented")

    mark_risk_stage_6_cat_4 = mark_risk_sub_category_4.where(title: 'Very convincing and promising strategy').first
    mark_risk_stage_6_cat_4.update(title: "Comprehensive market segmentation with addressable early adopting groups well defined")

    puts "Customer Segment sub_category is updated"
  end

  task update_risk_levels_10: :environment do
    # Marketing/Sales Strategy sub_category stages updates

    mark_risk_sub_category_5 = SubCategory.where(title: 'Marketing/Sales Strategy').first.stages

    mark_risk_stage_1_cat_5 = mark_risk_sub_category_5.where(title: 'Not addressed').first
    mark_risk_stage_1_cat_5.update(title: "No strategy")

    mark_risk_stage_2_cat_5 = mark_risk_sub_category_5.where(title: 'Identified with little diligence or assessment').first
    mark_risk_stage_2_cat_5.update(title: "Tactical ideas but holistic strategy not yet defined")

    mark_risk_stage_3_cat_5 = mark_risk_sub_category_5.where(title: 'Significant & active competition').first
    mark_risk_stage_3_cat_5.update(title: "Outline/strategy identifiable but no execution plan in place")

    mark_risk_stage_4_cat_5 = mark_risk_sub_category_5.where(title: 'Moderate competition active or expected').first
    mark_risk_stage_4_cat_5.update(title: "Execution plan in place")

    mark_risk_stage_5_cat_5 = mark_risk_sub_category_5.where(title: 'Weak competition active or expected; limited entry barriers').first
    mark_risk_stage_5_cat_5.update(title: "Execution plan and resources in place")

    puts "Marketing/Sales Strategy sub_category is updated"
  end

  task update_risk_levels_11: :environment do
    # Management Team Risk category stages updates

    management_risk_category = Category.where(title: 'Management Team Risk').first
    updated_management_risk_category = management_risk_category.update(title: 'Team Risk')

    updated_manag_category_stages_1 = SubCategory.where(title: 'Management Team').first.stages

    st_1 = updated_manag_category_stages_1.where(title: 'No notable experience').first
    st_1.update(title: 'Limited to no experience in these areas')

    st_2 = updated_manag_category_stages_1.where(title: 'Technology or domain experience only').first
    st_2.update(title: 'Mgmt team has experience in at least one of these categories')

    st_3 = updated_manag_category_stages_1.where(title: 'Technology / domain expert along with sales / marketing expertise').first
    st_3.update(title: 'Mgmt team has experience in at least 2 of these categories')

    st_4 = updated_manag_category_stages_1.where(title: 'Team with notable experience, but gaps exists').first
    st_4.update(title: 'Mgmt team has experience in these categories but gaps exist')

    st_5 = updated_manag_category_stages_1.where(title: 'Solid team with notable experience').first
    st_5.update(title: 'Mgmt team is complete and has all functions in place')

    stages_talent_sub_category = ['Not yet addressed', 'Critical talent being evaluated', 'Critical talent identified', 'Critical talent risk of talent flight evaluated', 'Risk mitigation plan in place to avoid talent flight']

    new_talent_sub_categ = updated_management_risk_category.sub_categories.create(title: 'Talent')

    i = 1
    stages_talent_sub_category.each do |stage|
      new_talent_sub_categ.stages.create(title: stage, position: i)
      i = i + 1
    end

    stages_alliance_partners_sub_categ = updated_management_risk_category.sub_categories.where(title: 'Alliance/Partners').first.stages

    alliance_st_1 = stages_alliance_partners_sub_categ.where(title: 'Unknown').first
    alliance_st_1.update(title: 'Not sure of partners I need')

    alliance_st_2 = stages_alliance_partners_sub_categ.where(title: 'Alliance partners identified').first
    alliance_st_2.update(title: 'Understanding of partner needs, not yet formalized')

    alliance_st_3 = stages_alliance_partners_sub_categ.where(title: 'Talks with potential partners commenced').first
    alliance_st_3.update(title: 'Some partners in place but gaps still exist')

    alliance_st_4 = stages_alliance_partners_sub_categ.where(title: 'Negotiations with all necessary partners commenced').first
    alliance_st_4.update(title: 'Most partners in place, formal agreements not yet secured')

    alliance_st_5 = stages_alliance_partners_sub_categ.where(title: 'Some alliances with partners closed but others still outstanding').first
    alliance_st_5.update(title: 'Some alliance agreements in place, others still outstanding')

    alliance_st_6 = stages_alliance_partners_sub_categ.where(title: 'All necessary alliances closed with A-List partners').first
    alliance_st_6.update(title: 'All necessary partners and agreements in place')

    stages_advisory_boards_sub_categ = updated_management_risk_category.sub_categories.where(title: 'Advisory Board').first.stages

    advisor_st_1 = stages_advisory_boards_sub_categ.where(title: 'Not addressed').first
    advisor_st_1.update(title: 'No current advisory board in place, not sure of if advisors are needed')

    advisor_st_4 = stages_advisory_boards_sub_categ.where(title: 'Some advisors committed').first
    advisor_st_4.update(title: 'Some advisors committed, negotiations taking place')

    advisor_st_5 = stages_advisory_boards_sub_categ.where(title: 'Some strong advisors committed').first
    advisor_st_5.update(title: 'Some advisors committed and agreements in place')

    advisor_st_6 = stages_advisory_boards_sub_categ.where(title: 'A-List technology & business advisors committed').first
    advisor_st_6.update(title: 'A list of technology & business advisors committed')

    implement_plan_sub_category = updated_management_risk_category.sub_categories.where(title: 'Implementation Plan').first
    implement_plan_sub_category.update(title: 'Strategic Plan')

    stages_implement_plan_sub_category = implement_plan_sub_category.stages

    implement_plan_st_1 = stages_implement_plan_sub_category.where(title: 'Not addressed')
    implement_plan_st_1.update(title: 'Not yet initiated')

    implement_plan_st_2 = stages_implement_plan_sub_category.where(title: 'Incomplete').first
    implement_plan_st_2.update(title: 'Initiated, not yet formalized in business plan')

    implement_plan_st_3 = stages_implement_plan_sub_category.where(title: 'Difficult to assess due to significant gaps').first
    implement_plan_st_3.update(title: 'Some elements in place, ie., exec summary, pitch deck, business plan but not yet complete')

    implement_plan_st_4 = stages_implement_plan_sub_category.where(title: 'Fairly realistic but planning incomplete').first
    implement_plan_st_4.update(title: 'Business strategy documented but gaps exist in execution of plan')

    implement_plan_st_5 = stages_implement_plan_sub_category.where(title: 'Realistic with thorough planning').first
    implement_plan_st_5.update(title: 'Business plan complete and resources in place')

    puts "Management Team Risk category is updated"
  end

  task update_risk_levels_12: :environment do
    # Product Design Risk category updates

    product_design_risk_category = Category.where(title: 'Product Design Risk').first

    new_sub_category_prod_design_category = product_design_risk_category.sub_categories.create(title: 'CRL-regulatory requirements (design product for regulatory or industry standards)')

    i = 1
    new_sub_category_prod_design_category_stages = ['Unknown', 'Limited understanding, not yet established', 'Evaluating, not clear on requirements', 'Identified regulatory requirements, not yet implemented', 'Implemented part of the plan', 'All regulatory requirements addressed and implemented']
    new_sub_category_prod_design_category_stages.each do |stage|
      new_sub_category_prod_design_category.stages.create(title: stage, position: i)
      i = i + 1
    end

    puts "Product Design Risk category is updated"
  end

  task update_risk_levels_13: :environment do
    # Insert new level to Market Risk below Customer Segment
    market_risk_category = Category.where(title: 'Market Risk').first

    sub_categories_market_risk = market_risk_category.sub_categories
    customer_segment_sub_category_id = sub_categories_market_risk.where(title: 'Customer Segment').first.id

    new_sub_category_market_risk = market_risk_category.sub_categories.create(title: 'VALUE CHAIN-CRL (go to market partners distributors, reps, resellers, logistics)')

    i = 1
    new_satges_new_sub_category_market_risk = ['Unknown', 'Limited understanding, not yet established', 'Value chain partners identified, no formal agreements in place', 'In discussion with value chain partners', 'Value chain partner agreements formalized']
    new_satges_new_sub_category_market_risk.each do |stage|
      new_sub_category_market_risk.stages.create(title: stage, position: i)
      i = i + 1
    end

    last_sub_category_id = SubCategory.last.id

    step = 2
    sub_categories_market_risk.each do |sub_category|
      if sub_category.id > customer_segment_sub_category_id
        sub_category.update(id: last_sub_category_id+step)
        step = step + 1
      end
    end

    new_sub_category_market_risk.update(id: last_sub_category_id+1)

    puts "Insert new level to Market Risk below Customer Segment is done"
  end
end
