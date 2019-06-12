class Testimonial
  include ActiveModel::Model

  def self.data
    DATA
  end

  DATA = [
    {
      quoted_text: "There's nothing it can't answer. I call it my healthcare Siri.",
      image_url: nil,
      name: "Dr. Albert Barrocas",
      title: "Chief Medical Officer",
      company: "Atlanta Medical Center"
    },
    {
      quoted_text: "The frustration patients have of not getting enough <em>time</em> with their healthcare providers is mirrored by the frustration healthcare providers have of not getting enough time with their patients. InpharmD&trade; saves me so much <em>time</em>, allowing me to focus more on the patient.",
      image_url: 'testimonial-photos/juan_lopez.png',
      name: "Juan Lopez, PharmD",
      title: "",
      company: ""
    },
    {
      quoted_text: "My colleagues and I find the product convenient, and as a result, are asking questions they would've just Googled before. ....This is becoming part of our culture.",
      image_url: nil,
      name: "Dr. Tanna Lim",
      title: "Internal Medicine Physician",
      company: "Atlanta Medical Center"
    },
    {
      quoted_text: "One's medical knowledge becomes obsolete within five years of graduation. We're trained to be lifelong learners, but unfortunately we no longer have the <em>resources</em> we once had. InpharmD&trade; changes everything.",
      image_url: 'testimonial-photos/john_bennett.jpg',
      name: "John Bennett, MD",
      title: "",
      company: ""
    },
    {
      quoted_text: "All the answers have been very helpful and were shared and discussed extensively on rounds. Some…allowed us to direct our clinical decisions.",
      image_url: nil,
      name: "Bhagyashree Shastri",
      title: "Internal Medicine Resident",
      company: "Atlanta Medical Center"
    },
    {
      quoted_text: "The lack of <em>accurate</em> and <em>timely</em> medical information can lead to adverse drug events and drug-drug interactions.",
      image_url: 'testimonial-photos/steven_handler.jpg',
      name: "Steven Handler, MD, PhD",
      title: "",
      company: ""
    },
    {
      quoted_text: "A must have resource for evidence based medicine!",
      image_url: nil,
      name: "Brittany Marley",
      title: "Emergency Medicine Physician’s Assistant",
      company: "Atlanta Medical Center"
    }
  ]


end
