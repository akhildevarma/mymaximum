require 'rails_helper'

describe TableParser do
  let(:table_json) do
    { body: 
      [
        [{ colspan: 7, rowspan: 1, value: 'Relationships of Incidence of Age-Related Macular Degeneration Outcomes' }],
        [{ colspan: 1, rowspan: 1, value: '' }, 
         { colspan: 1, rowspan: 1, value: 'Using aspirin 5 years prior to incidence' },
         { colspan: 1, rowspan: 1, value: 'Number at risk' }, 
         { colspan: 1, rowspan: 1, value: 'Incident Cases, number' },
         { colspan: 1, rowspan: 1, value: 'Age and Sex adjusted incidence (95% CI), %' },
         { colspan: 1, rowspan: 1, value: 'Hazard ratio (95% CI)' },
         { colspan: 1, rowspan: 1, value: 'P value' }
        ],
        [
          { colspan: 1, rowspan: 2, value: 'Early AMD' },
          { colspan: 1, rowspan: 1, value: 'No' }, 
          { colspan: 1, rowspan: 1, value: '4396' }, 
          { colspan: 1, rowspan: 1, value: '348' }, 
          { colspan: 1, rowspan: 1, value: '10.5 (9.5-11.6)' }, 
          { colspan: 1, rowspan: 1, value: '1' }, 
          { colspan: 1, rowspan: 2, value: '0.13' }
        ],
        [
          { colspan: 1, rowspan: 1, value: 'Yes' }, 
          { colspan: 1, rowspan: 1, value: '1845' }, 
          { colspan: 1, rowspan: 1, value: '164' }, 
          { colspan: 1, rowspan: 1, value: '9.6 (8.3-11)' },
          { colspan: 1, rowspan: 1, value: '0.86 (0.71-1.05)' }
        ]
      ]
    }
  end

  let(:table_html) do
    '<table>
       <tbody>
         <tr>
           <td colspan="7">
             <span>Relationships of Incidence of Age-Related Macular Degeneration Outcomes</span>
           </td> 
         </tr> 
         <tr> 
           <td> </td>
           <td> Using aspirin 5 years prior to incidence </td> 
           <td> Number at risk </td> 
           <td> Incident Cases, number </td>
           <td> Age and Sex adjusted incidence (95% CI), % </td>
           <td> Hazard ratio (95% CI) </td> 
           <td> P value </td>
         </tr>
         <tr> 
           <td rowspan="2"> Early AMD </td>
           <td> No </td>
           <td> 4396 </td> 
           <td> 348 </td>
           <td> 10.5 (9.5-11.6) </td> 
           <td> 1 </td>
           <td rowspan="2"> 0.13 </td> 
         </tr>
         <tr> 
           <td> Yes </td> 
           <td> 1845 </td> 
           <td> 164 </td> 
           <td> 9.6 (8.3-11) </td> 
           <td> 0.86 (0.71-1.05) </td> 
         </tr>
       </tbody>
     </table>' 
  end

   describe '.html_to_json' do
     it 'returns a 2x2 array of hashes with value, rowspan, and colspan properties' do
       expect(TableParser.html_to_json(table_html)).to eq(table_json)
     end

     it 'should ignore embedded tags' do
       expect(TableParser.html_to_json(table_html).to_json).to_not include('<span>')
     end
   end
end
