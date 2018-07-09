# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
      class Create
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          oneOf: [
            {
              type: :object,
              properties: {
                first_name: {
                  type: :string
                },
                last_name: {
                  type: :string
                },
                middle_name: {
                  type: %i[string null]
                },
                birth_place: {
                  type: :string
                },
                birth_date: {
                  type: :string,
                  pattern: /^[0-9]{1,2}.[0-9]{1,2}.[0-9]{4}$/
                },
                sex: {
                  type: :string,
                  enum: %w[male female]
                },
                citizenship: {
                  type: :string,
                  enum: %w[russian foreign absent]
                },
                snils: {
                  type: %i[string null],
                  pattern: /^[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}$/
                },
                inn: {
                  type: %i[string null],
                  pattern: /^[0-9]{12}$/
                },
                commercial_name: {
                  type: %i[string null]
                },
                ogrn: {
                  type: :string,
                  pattern: /^[0-9]{15}$/
                },
                registration_address: {
                  type: :object,
                  properties: {
                    zip: {
                      type: %i[string null]
                    },
                    region: {
                      type: %i[string null]
                    },
                    sub_region: {
                      type: %i[string null]
                    },
                    city: {
                      type: %i[string null]
                    },
                    settlement: {
                      type: %i[string null]
                    },
                    street: {
                      type: %i[string null]
                    },
                    house: {
                      type: %i[string null]
                    },
                    building: {
                      type: %i[string null]
                    },
                    appartment: {
                      type: %i[string null]
                    },
                    structure: {
                      type: %i[string null]
                    },
                    region_code: {
                      type: %i[string null]
                    },
                    fias: {
                      type: %i[string boolean null]
                    }
                  }
                },
                actual_address: {
                  type: :object,
                  properties: {
                    zip: {
                      type: %i[string null]
                    },
                    region: {
                      type: %i[string null]
                    },
                    sub_region: {
                      type: %i[string null]
                    },
                    city: {
                      type: %i[string null]
                    },
                    settlement: {
                      type: %i[string null]
                    },
                    street: {
                      type: %i[string null]
                    },
                    house: {
                      type: %i[string null]
                    },
                    building: {
                      type: %i[string null]
                    },
                    appartment: {
                      type: %i[string null]
                    },
                    structure: {
                      type: %i[string null]
                    },
                    region_code: {
                      type: %i[string null]
                    },
                    fias: {
                      type: %i[string boolean null]
                    }
                  }
                },
                identity_document: {
                  type: :object,
                  properties: {
                    type: {
                      type: :string,
                      enum: %w[
                        passport_rf
                        international_passport
                        seaman_passport
                        officer_identity_document
                        soldier_identity_document
                        temporary_identity_card
                        birth_certificate
                        foreign_citizen_passport
                        residence
                        temporary_residence
                        refugee_certificate
                        certificate_of_temporary_asylum_rf
                      ]
                    },
                    number: {
                      type: %i[string null]
                    },
                    series: {
                      type: :string
                    },
                    issued_by: {
                      type: :string
                    },
                    issue_date: {
                      type: :string
                    },
                    due_date: {
                      type: %i[string null]
                    },
                    content: {
                      type: :string
                    }
                  },
                  required: %i[
                    type
                    series
                    issued_by
                    issue_date
                    content
                  ]
                },
                consent_to_processing: {
                  type: :object,
                  properties: {
                    content: {
                      type: :string
                    }
                  },
                  required: %i[
                    content
                  ]
                },
                bank_details: {
                  type: %i[object null],
                  properties: {
                    bik: {
                      type: %i[string null]
                    },
                    account: {
                      type: %i[string null]
                    },
                    corr_account: {
                      type: %i[string null]
                    },
                    name: {
                      type: %i[string null]
                    }
                  }
                },
                spokesman: {
                  type: %i[object null],
                  properties: {
                    id: {
                      type: :string
                    },
                    title: {
                      type: :string
                    },
                    number: {
                      type: %i[string null]
                    },
                    series: {
                      type: %i[string null]
                    },
                    registry_number: {
                      type: %i[string null]
                    },
                    issued_by: {
                      type: :string
                    },
                    issue_date: {
                      type: :string
                    },
                    due_date: {
                      type: %i[string null]
                    },
                    content: {
                      type: :string
                    }
                  },
                  required: %i[
                    id
                    title
                    issued_by
                    issue_date
                    content
                  ]
                }
              },
              required: %i[
                first_name
                last_name
                birth_date
                inn
                sex
                citizenship
                ogrn
                registration_address
                actual_address
                identity_document
                consent_to_processing
              ]
            },
            {
              type: :object,
              properties: {
                individual_id: {
                  type: :string
                },
                commercial_name: {
                  type: %i[string null]
                },
                ogrn: {
                  type: :string
                },
                actual_address: {
                  type: :object,
                  properties: {
                    zip: {
                      type: %i[string null]
                    },
                    region: {
                      type: %i[string null]
                    },
                    sub_region: {
                      type: %i[string null]
                    },
                    city: {
                      type: %i[string null]
                    },
                    settlement: {
                      type: %i[string null]
                    },
                    street: {
                      type: %i[string null]
                    },
                    house: {
                      type: %i[string null]
                    },
                    building: {
                      type: %i[string null]
                    },
                    appartment: {
                      type: %i[string null]
                    },
                    structure: {
                      type: %i[string null]
                    },
                    region_code: {
                      type: %i[string null]
                    },
                    fias: {
                      type: %i[string boolean null]
                    }
                  }
                },
                bank_details: {
                  type: %i[object null],
                  properties: {
                    bik: {
                      type: %i[string null]
                    },
                    account: {
                      type: %i[string null]
                    },
                    corr_account: {
                      type: %i[string null]
                    },
                    name: {
                      type: %i[string null]
                    }
                  }
                },
                spokesman: {
                  type: %i[object null],
                  properties: {
                    id: {
                      type: :string
                    },
                    title: {
                      type: :string
                    },
                    number: {
                      type: %i[string null]
                    },
                    series: {
                      type: %i[string null]
                    },
                    registry_number: {
                      type: %i[string null]
                    },
                    issued_by: {
                      type: :string
                    },
                    issue_date: {
                      type: :string
                    },
                    due_date: {
                      type: %i[string null]
                    },
                    content: {
                      type: :string
                    }
                  },
                  required: %i[
                    id
                    title
                    issued_by
                    issue_date
                    content
                  ]
                }
              },
              required: %i[
                individual_id
                ogrn
                actual_address
              ]
            }
          ]
        }.freeze
      end
    end
  end
end
