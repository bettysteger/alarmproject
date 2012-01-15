module SpecHelperMethods
   
   def nothing_in_db
      Model.all.count.should == 0
      Point.all.count.should == 0
      Scenario.all.count.should == 0
      Value.all.count.should == 0
      Variable.all.count.should == 0
    end
    
    # delete json directory to cleanup
    def delete_json_directory
      Dir[@folder + "/json/*.json"].each do |file|
        File.delete(file)
      end
      Dir.delete(@folder + "/json")
    end
    
    def db_name
      Rails.application.class.parent_name.downcase + "_" + Rails.env
    end
    
    def create_dummy_data
      model = Model.create!(name: "Europe")
      scenario1 = Scenario.create!(name: "BAMBU")
      variable1 = Variable.create!(name: "pre")
      variable2 = Variable.create!(name: "tmp")
      point1 = Point.create!(x: 1, y: 2)
      point2 = Point.create!(x: 3, y: 4)

      # scenario1, variable1, two points
      Value.create!(year: 2001, month: 1, number: 1, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point1.id)
      Value.create!(year: 2001, month: 2, number: 2, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point1.id)
      Value.create!(year: 2001, month: 3, number: 3, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point1.id)

      Value.create!(year: 2001, month: 1, number: 4, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point2.id)
      Value.create!(year: 2001, month: 2, number: 5, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point2.id)
      Value.create!(year: 2001, month: 3, number: 6, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable1.id,
                    point_id: point2.id)
      
      # scenario1, variable2, two points
      Value.create!(year: 2001, month: 1, number: 7, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point1.id)
      Value.create!(year: 2001, month: 2, number: 8, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point1.id)
      Value.create!(year: 2001, month: 3, number: 9, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point1.id)

      Value.create!(year: 2001, month: 1, number: 10, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point2.id)
      Value.create!(year: 2001, month: 2, number: 11, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point2.id)
      Value.create!(year: 2001, month: 3, number: 12, model_id: model.id, 
                    scenario_id: scenario1.id, variable_id: variable2.id,
                    point_id: point2.id)
    end

end