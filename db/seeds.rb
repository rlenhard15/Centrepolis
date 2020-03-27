Assessment.destroy_all
Category.destroy_all
SubCategory.destroy_all
Stage.destroy_all

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
  }
]

records.each do |assesment|
  created_assesment = Assessment.create(name: assesment[:name])
  assesment[:categories].each do |category|
    created_category = created_assesment.categories.create(title: category[:title])
    category[:sub_categories].each do |sub_category|
      created_sub_category = created_category.sub_categories.create(title: sub_category[:title])
      sub_category[:stages].each_with_index do |stage, index|
        created_stage = created_sub_category.stages.create(title: stage[:title], position: index + 1)
      end
    end
  end
end
