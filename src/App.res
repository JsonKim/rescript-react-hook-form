@module("./logo.svg") external logo: string = "default"

%%raw(`import './App.css';`)

type useFormMethod<'a, 'b, 'c> = {
  register: 'a,
  handleSubmit: 'b,
  errors: 'c
}

@bs.val external alert: (string) => unit = "alert"

@bs.module("react-hook-form") external useForm: ('input) => useFormMethod<'a, 'b, 'c> = "useForm" 

type loginForm = {
  id: string,
  password: string,
  repeatedPassword: string,
}

@react.component
let make = () => {
  let { register, handleSubmit, errors } = useForm({
    "resolver": (values: loginForm) => {
      let { id, password, repeatedPassword } = values

      let makeError = (id, password) => {
        switch (id, password) {
        | (None, None) => None
        | (id, password) => Some({ id, password }) 
        }
      }

      let idError = Js.String.length(id) === 0 ? Some(`아이디를 입력해 주세요.`) : None
      let passwordError = switch (password, repeatedPassword) {
      | ("", _) => Some(`비밀번호를 입력해 주세요.`)
      | (_, "") => Some(`비밀번호확인을 입력해 주세요.`)
      | (p1, p2) when p1 !== p2 => Some(`비밀번호가 일치하지 않습니다.`)
      | (_, _) => None
      }

      let errors = makeError(idError, passwordError)
      switch errors {
      | None => { "values": Some(values), "errors": Some(Js.Obj.empty()) }
      | Some(error) => { "values": None, "errors": Some(error) }
      }
    }
  })

  let onSubmit = (data: loginForm) => {
    alert(`${data.id}로 로그인 되었습니다.`)
  }

  let onClick = handleSubmit(. onSubmit)

  let errorStyle = ReactDOM.Style.make(~color="#FF0000", ())

  <>
    <div>
      {React.string(`아이디`)}
      <input name="id" ref={ReactDOM.Ref.domRef(register)} />
      <div style=errorStyle>{React.string(errors["id"])}</div>
    </div>
    <div>
      {React.string(`비밀번호`)}
      <input name="password" ref={ReactDOM.Ref.domRef(register)} />
      <div style=errorStyle>{React.string(errors["password"])}</div>
    </div>
    <div>
      {React.string(`비밀번호 확인`)}
      <input name="repeatedPassword" ref={ReactDOM.Ref.domRef(register)} />
    </div>
    <div><button onClick>{React.string(`로그인`)}</button></div>
  </>
}
