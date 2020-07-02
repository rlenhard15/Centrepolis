records = [
  {
    name: "CRL (Commercial Readiness Level)",
    categories: [
      {
        title: 'IP Risk',
        sub_categories: [
          {
            title: 'Development Status',
            stages: [
              {title: 'Idea only'},
              {title: 'Basic tests showing potential'},
              {title: 'Prototype developed'},
              {title: 'Beta testing'},
              {title: 'Fully functional prototypes with customers'},
              {title: 'Sales to paying customers'}
            ]
          },
          {
            title: 'IP Advantage/Value',
            stages: [
              {title: 'Unknown	Little or no value'},
              {title: 'Limited advantage and difficult to defend'},
              {title: 'Proprietary know how/trade secrets'},
              {title: 'Some valuable and defensible IP'},
              {title: 'Significant and highly defensible IP'}
            ]
          },
          {
            title: 'Product Development Ownership:',
            stages: [
              {title: 'Fully outsourced'},
              {title: 'Partially outsourced with no development agreement in place'},
              {title: 'Partially outsourced with development agreements in place'},
              {title: 'Partially outsourced arrangements with strong development partners'},
              {title: 'Developed mostly in-house with some contracts with development partners'},
              {title: 'Developed fully in-house'}
            ]
          },
          {
            title: 'Competitive Technologies:',
            stages: [
              {title: 'Significant direct, indirect, and potential competing technologies'},
              {title: 'Limited direct and significant'},
              {title: 'Indirect competing technologies'},
              {title: 'Limited direct, but strong potential competitive technologies'},
              {title: 'Limited direct and indirect competing technologies'},
              {title: 'No direct and limited indirect competing technologies'},
              {title: 'No competing technologies'}
            ]
          }
        ]
      },
      {
        title: 'Market Risk',
        sub_categories: [
          {
            title: 'Value to Customer:',
            stages: [
              {title: 'Unknown'},
              {title: 'Unclear or low'},
              {title: 'Recognizable but low value'},
              {title: 'Value clear but not quantifiable'},
              {title: 'Value clear, somewhat moderate'},
              {title: 'Clear, quantifiable, high ROI'}
            ]
          },
          {
            title: 'Market Size',
            stages: [
              {title: 'No Market'},
              {title: 'Stagnating or diminishing market'},
              {title: 'Very small market'},
              {title: 'Small market'},
              {title: 'Moderate growing market'},
              {title: 'Large growing market'}
            ]
          },
          {
            title: 'Customer Segment',
            stages: [
              {title: 'Target group not defined'},
              {title: 'Target group vaguely or too broadly defined'},
              {title: 'Target group defined but difficult to recognize or approach'},
              {title: 'Target group defined but no market segmentation'},
              {title: 'Target group defined and market segmented'},
              {title: 'Strong addressable market segmentation with target group very well defined'}
            ]
          },
          {
            title: 'Marketing/Sales Strategy',
            stages: [
              {title: 'No Strategy'},
              {title: 'Tactical ideas but holistic strategy unclear'},
              {title: 'Outline / strategy identifiable but clear gaps exist'},
              {title: 'Strategy clearly recognizable with only modest gaps'},
              {title: 'Generally clear, consistent and complete strategy'},
              {title: 'Very convincing and promising strategy'}
            ]
          },
          {
            title: 'Competition (Direct & Indirect)',
            stages: [
              {title: 'Not addressed'},
              {title: 'Identified with little diligence or assessment'},
              {title: 'Significant & active competition'},
              {title: 'Moderate competition active or expected'},
              {title: 'Weak competition active or expected; limited entry barriers'},
              {title: 'Weak competition active or expected with significant entry barriers'}
            ]
          }
        ]
      },
      {
        title: 'Finance Risk',
        sub_categories: [
          {
            title: 'Revenue Model',
            stages: [
              {title: 'Not addressed'},
              {title: 'Addressed but unclear or poorly defined'},
              {title: 'Defined revenue model but unrealistic'},
              {title: 'Realistic revenue model'},
              {title: 'Clearly defined model with limited sources of revenue'},
              {title: 'Clearly defined model with multiple sources of revenue'}
            ]
          },
          {
            title: 'Financial Planning',
            stages: [
              {title: 'Critical Assumptions not present'},
              {title: 'Planning based on unrealistic assumptions'},
              {title: 'Planning based on somewhat unrealistic assumptions'},
              {title: 'Realistic assumptions but revenue potential only moderately attractive'},
              {title: 'Realistic assumptions with attractive revenue potential'},
              {title: 'Realistic assumptions with highly attractive revenue potential'}
            ]
          },
          {
            title: 'Cash Flow Requirements',
            stages: [
              {title: 'Operating at a loss, burn rate exceeds break-even requirements and less than 6 months of cash is on hand'},
              {title: 'Operating at a loss, burn rate exceeds break-even requirements but greater than 6 months of cash is on hand'},
              {title: 'Operating at a loss but burn rate is consistent with forecasting for break-even'},
              {title: 'Generally achieving break-even cashflow but not positive cashflow from operations'},
              {title: 'Generating minimal positive cashflow from operations'},
              {title: 'Generating strong, positive cashflow from operations'}
            ]
          },
          {
            title: 'Financing',
            stages: [
              {title: 'Undefined	Capital requirements and timing / milestones not validated'},
              {title: 'Timing / milestones acceptable, but capital requirements not validated'},
              {title: 'Capital requirements acceptable, but timing / milestones not validated'},
              {title: 'Capital requirements and timing / milestones validated and realistic'},
              {title: 'Capital requirements and timing / milestones very attractive'}
            ]
          }
        ]
      },
      {
        title: 'Management Team Risk',
        sub_categories: [
          {
            title: 'Management Team',
            stages: [
              {title: 'No notable experience'},
              {title: 'Technology or domain experience only'},
              {title: 'Technology / domain expert along with sales / marketing expertise'},
              {title: 'Team with notable experience, but gaps exists'},
              {title: 'Solid team with notable experience'},
              {title: 'Very strong team with notable experience and prior successful startups'}
            ]
          },
          {
            title: 'Alliance/Partners',
            stages: [
              {title: 'Unknown'},
              {title: 'Alliance partners identified'},
              {title: 'Talks with potential partners commenced'},
              {title: 'Negotiations with all necessary partners commenced'},
              {title: 'Some alliances with partners closed but others still outstanding'},
              {title: 'All necessary alliances closed with A-List partners'}
            ]
          },
          {
            title: 'Advisory Board',
            stages: [
              {title: 'Not addressed'},
              {title: 'Advisors identified'},
              {title: 'Some advisors approached but uncommitted'},
              {title: 'Some advisors committed'},
              {title: 'Some strong advisors committed'},
              {title: 'A-List technology & business advisors committed'}
            ]
          },
          {
            title: 'Implementation Plan',
            stages: [
              {title: 'Not addressed'},
              {title: 'Incomplete'},
              {title: 'Difficult to assess due to significant gaps'},
              {title: 'Fairly realistic but planning incomplete'},
              {title: 'Realistic with thorough planning'},
              {title: 'Highly realistic, easy to follow, thoroughly planned'}
            ]
          }
        ]
      }
    ]
  },
  {
    name: "MRL",
    categories: [
      {
        title: 'Product Design Risk',
        sub_categories: [
          {
            title: 'Customer Use:',
            stages: [
              {title: 'Not identified or specified'},
              {title: 'Limited details on customer use designed into product'},
              {title: 'Detailed customer use specs designed ino product'},
              {title: 'Prototypes shared with limited customers for feedback'},
              {title: 'Prototypes shared with significant number of customers for feedback'},
              {title: 'Customer tested product directly for use specs to validate product design'}
            ]
          },
          {
            title: 'Cost:',
            stages: [
              {title: 'Unknown'},
              {title: 'High level cost estimation of materials & components'},
              {title: 'High level Cost of Goods Sold (COGS)'},
              {title: 'Detailed Bill of Materials cost estimate'},
              {title: 'Detailed COGS'},
              {title: 'Intelligent COGS and production cost analysis at different volumes'},
            ]
          },
          {
            title: 'Durability/Reliability:',
            stages: [
              {title: 'Not measured or estimated'},
              {title: 'Evaluated internally through simulation(s) or prototype(s)'},
              {title: 'Evaluated internally through both prototype(s) and simulation(s) or DFMEA'},
              {title: 'Evaluated via experienced and trusted third party'},
              {title: 'Evaluated extensively by customer(s)'},
              {title: 'Tested extensively to life internally, external partner and/or customer'}
            ]
          },
          {
            title: 'Performance:',
            stages: [
              {title: 'Not measured or estimated'},
              {title: 'Evaluated internally through simulation(s) or prototype(s)'},
              {title: 'Evaluated internally through both prototype(s) and simulation(s)'},
              {title: 'Evaluated via experienced and trusted third party'},
              {title: 'Evaluated extensively by customer(s)'},
              {title: 'Tested extensively to life internally, external partner and/or customer'}
            ]
           }
          ]
          },
          {
            title: 'Management Team Risk',
            sub_categories: [
              {
                title: 'Management Team',
                stages: [
                  {title: 'No notable experience'},
                  {title: 'Technology or domain experience only'},
                  {title: 'Technology / domain expert along with sales / marketing expertise'},
                  {title: 'Team with notable experience, but gaps exists'},
                  {title: 'Solid team with notable experience'},
                  {title: 'Very strong team with notable experience and prior successful startups'}
                ]
              },
              {
                title: 'Alliance/Partners',
                stages: [
                  {title: 'Unknown'},
                  {title: 'Alliance partners identified'},
                  {title: 'Talks with potential partners commenced'},
                  {title: 'Negotiations with all necessary partners commenced'},
                  {title: 'Some alliances with partners closed but others still outstanding'},
                  {title: 'All necessary alliances closed with A-List partners'}
                ]
              },
              {
                title: 'Advisory Board',
                stages: [
                  {title: 'Not addressed'},
                  {title: 'Advisors identified'},
                  {title: 'Some advisors approached but uncommitted'},
                  {title: 'Some advisors committed'},
                  {title: 'Some strong advisors committed'},
                  {title: 'A-List technology & business advisors committed'}
                ]
              },
              {
                title: 'Implementation Plan',
                stages: [
                  {title: 'Not addressed'},
                  {title: 'Incomplete'},
                  {title: 'Difficult to assess due to significant gaps'},
                  {title: 'Fairly realistic but planning incomplete'},
                  {title: 'Realistic with thorough planning'},
                  {title: 'Highly realistic, easy to follow, thoroughly planned'}
                ]
              }
            ]
           },
           {
              title: 'Manufacturing Risk',
              sub_categories: [
                {
                  title: 'Materials:',
                  stages: [
                    {title: 'Not fully evaluated'},
                    {title: 'Limited material testing, evaluation, or alternatives considered'},
                    {title: 'Some material testing, evaluation, alternatives considered'},
                    {title: 'Some testing, evaluation of materials'},
                    {title: 'Comprehensive material testing, evaluation, many alternatives considered'}
                  ]
                },
                {
                  title: 'Tooling:',
                  stages: [
                    {title: 'No understanding of tooling being used or required to make product'},
                    {title: 'Limited understanding of tooling being used or required to make product'},
                    {title: 'Tooling design considerations being evaluated now'},
                    {title: 'Tooling design well understood'},
                    {title: 'Tooling design and tooling cost well understood'}
                  ]
                },
                {
                  title: 'Manufacturing Equipment:',
                  stages: [
                    {title: 'No understanding of mfg equip being used or required to make product'},
                    {title: 'Limited understanding of mfg equip being used or required to make product'},
                    {title: 'Mfg equip considerations being evaluated now'},
                    {title: 'Mfg equip well understood'},
                    {title: 'Mfg equip, capacity constraints and capital cost well understood'}
                  ]
                },
                {
                  title: 'Manufacturing Process Validation:',
                  stages: [
                    {title: 'No knowledge of Production and Workflow Process'},
                    {title: 'Limited knowledge of Production and Workflow Process'},
                    {title: 'Production and Workflow Process plan in place but not validated'},
                    {title: 'Production and Workflow Process plan in place and validated through PFMEA'},
                    {title: 'Production and Workflow Process plan in place and validated through actual audit'}
                  ]
                },
                {
                  title: 'Manufacturing Process Efficiency:',
                  stages: [
                    {title: 'Production and Workflow Process without lean assessment'},
                    {title: 'Production and Workflow Process evaluated through high level lean assessment'},
                    {title: 'Production and Workflow Process evaluated through detailed lean assessment'},
                    {title: 'Production and Workflow Process evaluated through detailed lean assessment and quality audit'},
                    {title: 'Production and Workflow Process certified to Lean Mfg, ISO, Quality standards'}
                  ]
                }
             ]
           },
           {
             title: 'Supply Chain Risk',
             sub_categories: [
               {
                 title: 'Supplier Identifaction:',
                 stages: [
                   {title: 'No suppliers identified but needed'},
                   {title: 'Supplier search started but not complete'},
                   {title: 'Suppliers identified but not multiple sources'},
                   {title: 'Multiple suppliers identified for each material/component'},
                   {title: 'Multiple suppliers identified for each material/component, contacted and in discussions'}
                 ]
               },
               {
                 title: 'Supplier Evaluation:',
                 stages: [
                   {title: 'Not evaluated or no formal process for evaluation'},
                   {title: 'Limited evaluation of suppliers but no formal process for evaluation'},
                   {title: 'Evaluation of suppliers including formal process for evaluation (cost, performance, lead time, quality)'},
                   {title: 'Evaluation of suppliers includes on-site audit'},
                   {title: 'Evaluation of suppliers includes detailed on-site audit to verify performance, quality takt time'}
                 ]
               },
               {
                 title: 'Supplier Agreements:',
                 stages: [
                   {title: 'No formal supplier agreements in place'},
                   {title: 'Limited suppliers agreements in place (NDA’s, PO’s, contracts)'},
                   {title: 'Most supplier agreements in place (NDA’s, PO’s, contracts)'},
                   {title: 'Agreements include alternative procurement terms (e.g., volume, delivery time) and clear ownership of quality issues (e.g., product yield, failures)'},
                   {title: 'Agreements include alternative procurement terms and supplier reward and/or penalty compensation contracting terms associated with performance, quality, lead time measures'}
                 ]
               },
               {
                 title: 'Supply Chain Plan:',
                 stages: [
                   {title: 'No supply chain plan or supplier risk assessment in place'},
                   {title: 'Weak supply chain plan or limited supplier risk assessment in place'},
                   {title: 'Supply chain strategy and risk mitigation includes multiple sources under contract for each component'},
                   {title: 'Supply chain strategy and risk mitigation includes lead time guarantees for each component'},
                   {title: 'Detailed supply chain strategy followed, supply chain quality tracing in place, ERP systems connected'}
                 ]
               }
              ]
            }
          ]
        },
  {
         name: "TRL",
         categories: [
           {
             title: 'Technology Risk',
             sub_categories: [
               {
                 title: 'Basic Tech Research',
                 stages: [
                   {title: 'Basic Principles Observed and Reporte'},
                   {title: 'Technology Concept and/or Application Formulate'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environmen'},
                   {title: 'System validation, testing in operating environmen'},
                   {title: 'Prototype/pilot system verification in operating environmen'},
                   {title: 'Full Scale prototype verified in operating environmen'},
                   {title: 'Actual system complete and functioning in operating environmen'},
                   {title: 'Actual system tested and data collected over lifetime of syste'}
                 ]
               },
               {
                 title: 'Feasibility Research',
                 stages: [
                   {title: 'Basic Principles Observed and Reported'},
                   {title: 'Technology Concept and/or Application Formulated'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environment'},
                   {title: 'System validation, testing in operating environment'},
                   {title: 'Prototype/pilot system verification in operating environment'},
                   {title: 'Full Scale prototype verified in operating environment'},
                   {title: 'Actual system complete and functioning in operating environment'},
                   {title: 'Actual system tested and data collected over lifetime of system'}
                 ]
               },
               {
                 title: 'Tech Development',
                 stages: [
                   {title: 'Basic Principles Observed and Reported'},
                   {title: 'Technology Concept and/or Application Formulated'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environment'},
                   {title: 'System validation, testing in operating environment'},
                   {title: 'Prototype/pilot system verification in operating environment'},
                   {title: 'Full Scale prototype verified in operating environment'},
                   {title: 'Actual system complete and functioning in operating environment'},
                   {title: 'Actual system tested and data collected over lifetime of system'}
                 ]
               },
               {
                 title: 'Tech Demonstration',
                 stages: [
                   {title: 'Basic Principles Observed and Reported'},
                   {title: 'Technology Concept and/or Application Formulated'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environment'},
                   {title: 'System validation, testing in operating environment'},
                   {title: 'Prototype/pilot system verification in operating environment'},
                   {title: 'Full Scale prototype verified in operating environment'},
                   {title: 'Actual system complete and functioning in operating environment'},
                   {title: 'Actual system tested and data collected over lifetime of system'}
                 ]
               },
               {
                 title: 'System Commissioning',
                 stages: [
                   {title: 'Basic Principles Observed and Reported'},
                   {title: 'Technology Concept and/or Application Formulated'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environment'},
                   {title: 'System validation, testing in operating environment'},
                   {title: 'Prototype/pilot system verification in operating environment'},
                   {title: 'Full Scale prototype verified in operating environment'},
                   {title: 'Actual system complete and functioning in operating environment'},
                   {title: 'Actual system tested and data collected over lifetime of system'}
                 ]
               },
               {
                 title: 'System Operation',
                 stages: [
                   {title: 'Basic Principles Observed and Reported'},
                   {title: 'Technology Concept and/or Application Formulated'},
                   {title: 'Proof of concept analyzed and experimented on'},
                   {title: 'System validation in lab environment'},
                   {title: 'System validation, testing in operating environment'},
                   {title: 'Prototype/pilot system verification in operating environment'},
                   {title: 'Full Scale prototype verified in operating environment'},
                   {title: 'Actual system complete and functioning in operating environment'},
                   {title: 'Actual system tested and data collected over lifetime of system'}
                 ]
               }
             ]
           }
         ]
       }
]

records.each do |assesment|
  created_assesment = Assessment.where(name: assesment[:name]).first_or_create
  assesment[:categories].each do |category|
    created_category = created_assesment.categories.where(title: category[:title]).first_or_create
    category[:sub_categories].each do |sub_category|
      created_sub_category = created_category.sub_categories.where(title: sub_category[:title]).first_or_create
      sub_category[:stages].each_with_index do |stage, index|
        created_stage = created_sub_category.stages.where(title: stage[:title]).first_or_create{|stage| stage.position = index + 1}
      end
    end
  end
end

accelerators = [
  {
    name: 'Centeropolis'
  },
  {
    name: 'LeanRocketLab'
  },
  {
    name: 'FuzeHub'
  }
]

accelerators.each do |accelerator|
  Accelerator.where(name: accelerator[:name]).first_or_create
end
