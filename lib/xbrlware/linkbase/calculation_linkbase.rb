#!/usr/bin/ruby
#
# Author:: xbrlware@bitstat.com
#
# Copyright:: 2009, 2010 bitstat (http://www.bitstat.com). All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
module Xbrlware
  module Linkbase
    class CalculationLinkbase < Linkbase
      # Creates a CalculationLinkbase.
      #
      # linkbase_path::
      #   XBRL Calculation Linkbase source. Tries to load and parse calculationlinkbase from path.
      #
      # instance::
      #   Instance object
      #
      # label_linkbase::
      #   optional parameter, LabelLinkbase object
      def initialize(linkbase_path, instance, label_linkbase=nil)
        super linkbase_path
        @instance=instance
        @label_linkbase=label_linkbase
      end

      def calculation(role=nil)
        calculations=[]
        calc_content=@linkbase_content["calculationLink"]
        calc_content.each do |cal|

          next unless cal["xlink:role"]==role unless role.nil?

          if cal["calculationArc"].nil?
            calculations << Calculation.new(@instance.entity_details, cal["xlink:title"], cal["xlink:role"], @role_map[cal["xlink:role"]])
          else
            contexts_and_arcs=arcs(cal)
            calculations << Calculation.new(@instance.entity_details, cal["xlink:title"], cal["xlink:role"], @role_map[cal["xlink:role"]], contexts_and_arcs["arcs"], contexts_and_arcs["contexts"])
          end
        end
        return calculations[0] unless role.nil?
        calculations
      end

      private
      def arcs(calc)
        locators={}
        calc["loc"].each do |loc|
          href = loc["xlink:href"]
          unless href.index("#").nil?
            locators[loc["xlink:label"]]= href[href.index("#")+1, href.length]
          else
            locators[loc["xlink:label"]]=href
          end
        end

        arc_map={}
        contexts = Set.new()

        calc["calculationArc"].each do |arc|
          to_label = nil
          unless @label_linkbase.nil?
            to_label_obj=@label_linkbase.label(locators[arc["xlink:to"]], arc["preferredLabel"]) unless arc["preferredLabel"].nil?
            to_label_obj=@label_linkbase.label(locators[arc["xlink:to"]], "http://www.xbrl.org/2003/role/label") if arc["preferredLabel"].nil?
            to_label = to_label_obj.value unless to_label_obj.nil?
          end

          to = Calculation::CalculationArc.new(arc["xlink:to"], locators[arc["xlink:to"]], arc["xlink:arcrole"], arc["order"], arc["weight"], arc["priority"], arc["use"], to_label)
          from = Calculation::CalculationArc.new(arc["xlink:from"], locators[arc["xlink:from"]])

          to_item_name = locators[arc["xlink:to"]].gsub(/.*_/, "")
          from_item_name = locators[arc["xlink:from"]].gsub(/.*_/, "")

          to_item_map=item_map(@instance.item(to_item_name))
          to.items=to_item_map.values
          contexts.merge(to_item_map.keys)

          from_item_map=item_map(@instance.item(from_item_name))
          from.items=from_item_map.values
          contexts.merge(from_item_map.keys)

          if arc_map.has_key?(from)
            arc_map[from] << to
          else
            arc_map[from]=[to]
          end
        end

        return {"contexts" => contexts, "arcs" => Linkbase.build_relationship(arc_map)}
      end

      private
      def item_map(items)
        item_map={}
        items.each do |item|
          item_map[item.context]=item
        end unless items.nil?
        item_map
      end

      public
      class Calculation < Linkbase::Link

        attr_reader :contexts, :entity_details

        def initialize(entity_details, title, role, href=nil, arcs=nil, contexts=nil)
          super(title, role, href, arcs)
          @contexts=contexts
          @entity_details=entity_details
        end

        class CalculationArc < Linkbase::Link::Arc
          attr_reader :weight, :use

          def initialize(item_id, href, role=nil, order=nil, weight=nil, priority=nil, use=nil, label=nil)
            super item_id, href, role, order, priority, label
            @weight=weight.to_i
            @use=use
          end
        end
      end

    end
  end
end