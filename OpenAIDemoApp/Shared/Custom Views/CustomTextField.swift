//
//  OHTextField.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import SwiftUI

struct CustomTextField: View {
    
    let promptText: String
    let contentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let isPassword: Bool
    
    @Binding var text: String
    @Binding var isValid: Bool
    @Binding var errorMessages: [CustomTextFieldErrorMessage]
    
    @State var isClearText: Bool
    
    var onCommit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(promptText)
                .foregroundColor(.appBlack39)
                .font(.appRegular(size: 14))
            
            textField.padding(.top, 2)
            
            if !errorMessages.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(errorMessages) { error in
                        HStack(spacing: 8) {
                            if let image = error.image {
                                Image(image)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                            
                            Text(error.text)
                                .bodySmall()
                                .lineLimit(nil)
                                
                        }.foregroundColor(error.color)
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var textField: some View {
        ZStack(alignment: .trailing) {
            let extraPadding: CGFloat = isPassword ? 32 : 32
            
            textFieldType
                .foregroundColor(isValid ? .appBlack39 : .appRed3D)
                .font(.appRegular(size: 13))
                .textFieldStyle(
                    STTextFieldStyle(isValid: $isValid, extraRightPadding: extraPadding))
                .textContentType(contentType)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
            
            if isPassword {
                showHideTextButton.padding(.trailing, 4)
            }
        }
    }
    
    var showHideTextButton: some View {
        Button(
            action: {
                isClearText.toggle()
            },
            label: {
                Image((isClearText ? ImageResource.appShowPassword : ImageResource.appHidePassword))
                
            }
        ).frame(width: 40, height: 40)
    }
    
    private var textFieldType: some View {
        if isClearText {
            return AnyView(TextField("", text: $text, onCommit: onCommit))
                
        } else {
            return AnyView(SecureField("", text: $text, onCommit: onCommit))
        }
    }
}

struct STTextFieldStyle: TextFieldStyle {
    @Binding var isValid: Bool
    
    var extraRightPadding: CGFloat = 0
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .padding(.trailing, extraRightPadding)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(isValid ? Color.gray : Color.appRed3D, lineWidth: 1)
                
            )
    }
}

struct OHTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextField(
                promptText: "Email",
                contentType: nil, keyboardType: .default,
                isPassword: false,
                text: Binding.constant("abc"),
                isValid: .constant(true),
                errorMessages: .constant([]),
                isClearText: true,
                onCommit: {}
            ).previewLayout(.fixed(width: 375, height: 200))
            
            CustomTextField(
                promptText: "Email",
                contentType: nil, keyboardType: .default,
                isPassword: false,
                text: Binding.constant("abc"),
                isValid: .constant(false),
                errorMessages: .constant(
                    [CustomTextFieldErrorMessage(text: "Invalid email format")]
                ),
                isClearText: true,
                onCommit: {}
            )
            .padding()
            .previewLayout(.fixed(width: 375, height: 200))
            
            CustomTextField(
                promptText: "Password",
                contentType: nil, keyboardType: .default,
                isPassword: true,
                text: Binding.constant("abc"),
                isValid: .constant(false),
                errorMessages: .constant(
                    [
                        CustomTextFieldErrorMessage(image: .appInvalidCircle, text: "Invalid Password")
                    ]
                ),
                isClearText: false,
                onCommit: {}
            )
            .padding()
            .previewLayout(.fixed(width: 375, height: 200))
        }
    }
}
