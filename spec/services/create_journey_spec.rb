require "rails_helper"

RSpec.describe CreateJourney do
  around do |example|
    ClimateControl.modify(
      CONTENTFUL_DEFAULT_CATEGORY_ENTRY_ID: "contentful-category-entry"
    ) do
      example.run
    end
  end

  describe "#call" do
    it "creates a new journey" do
      stub_contentful_category(
        fixture_filename: "category-with-no-steps.json",
        stub_steps: false
      )
      expect { described_class.new(category_name: "catering").call }
        .to change { Journey.count }.by(1)
      expect(Journey.last.category).to eql("catering")
    end

    it "stores a copy of the Liquid template" do
      stub_contentful_category(
        fixture_filename: "category-with-liquid-template.json"
      )

      described_class.new(category_name: "catering").call

      expect(Journey.last.liquid_template)
        .to eql("<article id='specification'><h1>Liquid {{templating}}</h1></article>")
    end

    it "stores the section grouping on the journey in the expected order" do
      stub_contentful_category(
        fixture_filename: "multiple-sections-and-steps.json"
      )

      described_class.new(category_name: "catering").call

      journey = Journey.last

      expect(journey.reload.section_groups).to eq([
        {
          "order" => 0,
          "title" => "Section A",
          "steps" => [
            {"contentful_id" => "radio-question", "order" => 0},
            {"contentful_id" => "single-date-question", "order" => 1}
          ]
        },
        {
          "order" => 1,
          "title" => "Section B",
          "steps" => [
            {"contentful_id" => "long-text-question", "order" => 0},
            {"contentful_id" => "short-text-question", "order" => 1}
          ]
        }
      ])
    end
  end
end
