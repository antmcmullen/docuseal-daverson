# frozen_string_literal: true

# Daverson Hall branding for the PDFs DocuSeal generates (the audit log and the signed documents).
#
# These are the hook methods DocuSeal itself leaves for customisation. The logo images come from
# lib/pdf_icons/, which this overlay replaces. Checked against DocuSeal 3.3.8:
# - Submissions::GenerateAuditTrail.add_logo(column, submission) draws the header of the audit log
# - Submissions::GenerateAuditTrail.sign_reason is the reason shown in the audit log's PDF signature
# - Submissions::GenerateResultAttachments::SIGN_REASON is the reason shown in signed documents' PDF signatures
#
# Arguments are accepted loosely so that an upstream signature change can't break signing.
Rails.application.config.to_prepare do
  sign_reason = 'Signed via sign.daversonhall.co.uk'

  Submissions::GenerateAuditTrail.singleton_class.prepend(
    Module.new do
      define_method(:add_logo) do |column, *_args, **_kwargs|
        column.image(PdfIcons.logo_io, width: 40, height: 40, position: :float)

        column.formatted_text([{ text: 'Daverson Hall', link: 'https://www.daversonhall.co.uk' }],
                              font_size: 20,
                              font: [Submissions::GenerateAuditTrail::FONT_NAME, { variant: :bold }],
                              width: 200,
                              padding: [5, 0, 0, 8],
                              position: :float, text_align: :left)
      end

      define_method(:sign_reason) { |*_args| sign_reason }
    end
  )

  if Submissions::GenerateResultAttachments.const_defined?(:SIGN_REASON, false)
    Submissions::GenerateResultAttachments.send(:remove_const, :SIGN_REASON)
  end
  Submissions::GenerateResultAttachments.const_set(:SIGN_REASON, sign_reason)
end
