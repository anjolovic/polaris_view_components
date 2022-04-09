# frozen_string_literal: true

module Polaris
  class PageComponent < Polaris::Component
    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_actions, Polaris::ButtonComponent
    renders_one :title_metadata
    renders_one :thumbnail, Polaris::ThumbnailComponent

    def initialize(
      title: nil,
      subtitle: nil,
      compact_title: false,
      back_url: nil,
      prev_url: nil,
      next_url: nil,
      narrow_width: false,
      full_width: false,
      divider: false,
      **system_arguments
    )
      @title = title
      @subtitle = subtitle
      @compact_title = compact_title
      @back_url = back_url
      @prev_url = prev_url
      @next_url = next_url

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Page",
        "Polaris-Page--narrowWidth": narrow_width,
        "Polaris-Page--fullWidth": full_width
      )

      @header_arguments = {}
      @header_arguments[:tag] = "div"
      @header_arguments[:classes] = class_names(
        "Polaris-Page-Header",
        "Polaris-Page-Header--mobileView",
        "Polaris-Page-Header--mediumTitle",
        "Polaris-Page-Header--hasNavigation": back_url.present?,
        "Polaris-Page-Header--noBreadcrumbs": back_url.blank?
      )

      @content_arguments = {}
      @content_arguments[:tag] = "div"
      @content_arguments[:classes] = class_names(
        "Polaris-Page__Content",
        "Polaris-Page--divider": divider
      )
    end

    def subtitle_arguments
      {
        tag: "div",
        classes: class_names(
          "Polaris-Header-Title__SubTitle",
          "Polaris-Header-Title__SubtitleCompact": @compact_title
        )
      }
    end

    def render_header?
      @title.present? || @subtitle.present? || @back_url.present? || primary_action.present?
    end

    def has_pagination?
      @next_url.present? || @prev_url.present?
    end
  end
end
