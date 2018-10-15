require 'spec_helper'

class MockSite
  attr_reader :config

  def initialize(config)
    @config = config
  end
end

class MockContext
  attr_reader :registers
  def initialize(config)
    @registers = {
      site: MockSite.new(config)
    }
  end
end

class MockSiteContext
  include Jekyll::Contentful::RichTextFilter

  def initialize(config)
    @context = MockContext.new(config)
  end
end

class MyRenderer < RichTextRenderer::BaseNodeRenderer
  def render(node)
    return "<div>I eat nodes for breakfast</div>"
  end
end

describe Jekyll::Contentful::RichTextFilter do
  let(:config) do
    {
      'contentful' => {
        'spaces' => [
          'foo' => {
            'rich_text_mappings' => {
              'embedded-entry-block' => 'MyRenderer'
            }
          },
          'bar' => {
          }
        ]
      }
    }
  end

  let(:rt_field) do
    {
      "content" => [
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "Some heading",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "heading-1",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
            "sys" => {
              "id" => "49rofLvvxCOiIMIi6mk8ai",
              "created_at" => "2018-08-22T10:45:20+00:00",
              "updated_at" => "2018-08-22T10:45:20+00:00",
              "content_type_id" => "embedded",
              "revision" => 1
            },
            "body" => "Embedded 1"
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "embedded-entry-block",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "Some subheading",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "heading-2",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [
                {
                  "data" => {
                  },
                  "type" => "bold",
                  "object" => "mark"
                }
              ],
              "value" => "Some bold",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [
                {
                  "data" => {
                  },
                  "type" => "italic",
                  "object" => "mark"
                }
              ],
              "value" => "Some italics",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [
                {
                  "data" => {
                  },
                  "type" => "underline",
                  "object" => "mark"
                }
              ],
              "value" => "Some underline",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
            "sys" => {
              "id" => "5ZF9Q4K6iWSYIU2OUs0UaQ",
              "created_at" => "2018-08-22T10:45:29+00:00",
              "updated_at" => "2018-08-22T10:45:29+00:00",
              "content_type_id" => "embedded",
              "revision" => 1
            },
            "body" => "Embedded 2"
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "embedded-entry-block",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "Some raw content",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "An unpublished embed:",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "Some more content",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [
                {
                  "data" => {
                  },
                  "type" => "code",
                  "object" => "mark"
                }
              ],
              "value" => "Some code",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            },
            {
              "data" => {
                "uri" => "https://www.contentful.com"
              },
              "content" => [
                {
                  "marks" => [

                  ],
                  "value" => "A hyperlink",
                  "nodeType" => "text",
                  "nodeClass" => "text"
                }
              ],
              "nodeType" => "hyperlink",
              "nodeClass" => "inline"
            },
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "data" => {
              },
              "content" => [
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "marks" => [

                      ],
                      "value" => "Ul list",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    }
                  ],
                  "nodeType" => "paragraph",
                  "nodeClass" => "block"
                }
              ],
              "nodeType" => "list-item",
              "nodeClass" => "block"
            },
            {
              "data" => {
              },
              "content" => [
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "marks" => [

                      ],
                      "value" => "A few ",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    },
                    {
                      "marks" => [
                        {
                          "data" => {
                          },
                          "type" => "bold",
                          "object" => "mark"
                        }
                      ],
                      "value" => "items",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    }
                  ],
                  "nodeType" => "paragraph",
                  "nodeClass" => "block"
                },
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "data" => {
                      },
                      "content" => [
                        {
                          "data" => {
                          },
                          "content" => [
                            {
                              "marks" => [

                              ],
                              "value" => "Ordered list nested inside an Unordered list item",
                              "nodeType" => "text",
                              "nodeClass" => "text"
                            }
                          ],
                          "nodeType" => "paragraph",
                          "nodeClass" => "block"
                        }
                      ],
                      "nodeType" => "list-item",
                      "nodeClass" => "block"
                    }
                  ],
                  "nodeType" => "ordered-list",
                  "nodeClass" => "block"
                }
              ],
              "nodeType" => "list-item",
              "nodeClass" => "block"
            }
          ],
          "nodeType" => "unordered-list",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "data" => {
              },
              "content" => [
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "marks" => [

                      ],
                      "value" => "Ol list",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    }
                  ],
                  "nodeType" => "paragraph",
                  "nodeClass" => "block"
                }
              ],
              "nodeType" => "list-item",
              "nodeClass" => "block"
            },
            {
              "data" => {
              },
              "content" => [
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "marks" => [

                      ],
                      "value" => "two",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    }
                  ],
                  "nodeType" => "paragraph",
                  "nodeClass" => "block"
                }
              ],
              "nodeType" => "list-item",
              "nodeClass" => "block"
            },
            {
              "data" => {
              },
              "content" => [
                {
                  "data" => {
                  },
                  "content" => [
                    {
                      "marks" => [

                      ],
                      "value" => "three",
                      "nodeType" => "text",
                      "nodeClass" => "text"
                    }
                  ],
                  "nodeType" => "paragraph",
                  "nodeClass" => "block"
                }
              ],
              "nodeType" => "list-item",
              "nodeClass" => "block"
            }
          ],
          "nodeType" => "ordered-list",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "hr",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "data" => {
              },
              "content" => [
                {
                  "marks" => [

                  ],
                  "value" => "An inspirational quote",
                  "nodeType" => "text",
                  "nodeClass" => "text"
                }
              ],
              "nodeType" => "paragraph",
              "nodeClass" => "block"
            },
            {
              "data" => {
              },
              "content" => [
                {
                  "marks" => [

                  ],
                  "value" => "",
                  "nodeType" => "text",
                  "nodeClass" => "text"
                }
              ],
              "nodeType" => "paragraph",
              "nodeClass" => "block"
            }
          ],
          "nodeType" => "blockquote",
          "nodeClass" => "block"
        },
        {
          "data" => {
          },
          "content" => [
            {
              "marks" => [

              ],
              "value" => "",
              "nodeType" => "text",
              "nodeClass" => "text"
            }
          ],
          "nodeType" => "paragraph",
          "nodeClass" => "block"
        }
      ],
      "nodeType" => "document",
      "nodeClass" => "document"
    }
  end

  subject { MockSiteContext.new(config) }

  describe 'renders rich text' do
    it 'by defaults uses first available config' do
      result = subject.rich_text(rt_field)

      expect(result).to include("<div>I eat nodes for breakfast</div>")
    end

    it 'can define which space configuration to use' do
      result = subject.rich_text(rt_field, 'foo')
      expect(result).to include("<div>I eat nodes for breakfast</div>")

      result = subject.rich_text(rt_field, 'bar')
      expect(result).not_to include("<div>I eat nodes for breakfast</div>")
    end
  end
end
