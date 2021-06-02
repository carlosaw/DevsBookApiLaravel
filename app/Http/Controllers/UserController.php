<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\User;
use App\UserRelation;
use App\Post;
use Image;

class UserController extends Controller
{
    private $loggedUser;

    public function __construct() {
        $this->middleware('auth:api');
        $this->loggedUser = auth()->user();
    }

    public function update(Request $request) {
        // PUT api/user (name, email, birthdate, city, work, password, password_confirm)
        $array = ['error' => ''];

        // Pega todos os campos
        $name = $request->input('name');
        $email = $request->input('email');
        $birthdate = $request->input('birthdate');
        $city = $request->input('city');
        $work = $request->input('work');
        $password = $request->input('password');
        $password_confirm = $request->input('password_confirm');

        $user = User::find($this->loggedUser['id']);//Pega usuario logadfo
        // NAME
        if($name) {// Se trocou nome pega o nome
            $user->name = $name;
        }

        // EMAIL
        if($email) {// se mandou email
            if($email != $user->email) {// Se email diferente do atual
                $emailExists = User::where('email', $email)->count(); 
                if($emailExists === 0) {// não tem usuario com novo email
                    $user->email = $email;// troca email
                } else {
                    $array['error'] = 'E-mail já existe';
                    return $array;
                }
            }
        }

        // BIRTHDATE
        if($birthdate) {// Se mandou data nasc...
            if(strtotime($birthdate) === false) {// Se é inválida...
                $array['error'] = 'Data de nascimento Inválida!';
                return $array;
            }
            // Senão troca data de nascimento
            $user->birthdate = $birthdate;           
        }
        

        // CITY
        if($city) {
            $user->city = $city;
        }
        // WORK
        if($work) {
            $user->work = $work;
        }

        // SENHA
        if($password && $password_confirm) {
            if($password === $password_confirm) {

                $hash = password_hash($password, PASSWORD_DEFAULT);
                $user->password = $hash;

            } else {
                $array['error'] = 'Senhas não conferem!';
                return $array;
            }
        }

        $user->save();

        return $array;
    }

    public function updateAvatar(Request $request) {
        $array = ['error' => ''];
        // Tipos de imagens permitidos
        $allowedTypes = ['image/jpg', 'image/jpeg', 'image/png'];

        $image = $request->file('avatar');

        if($image) {
            // Se imagem é do tipo permitido
            if(in_array($image->getClientMimeType(), $allowedTypes)) {

                // Cria nome da imagem
                $filename = md5(time().rand(0,9999)).'.jpg';

                // Salva na pasta media/avatars
                $destPath = public_path('/media/avatars');

                // Manipulação de imagens
                $img = Image::make($image->path())
                    ->fit(200, 200)
                    ->save($destPath.'/'.$filename);

                // Pega usuário logado e troca avatar
                $user = User::find($this->loggedUser['id']);
                $user->avatar = $filename;
                $user->save();

                // Retorna nova url da imagem
                $array['url'] = url('/media/avatars/'.$filename);

            } else {
                $array['error'] = 'Arquivo não suportado!';
                return $array;
            }

        } else {
            $array['error'] = 'Arquivo não enviado!';
            return $array;
        }

        return $array;
    }

    public function updateCover(Request $request) {
        $array = ['error' => ''];
        // Tipos de imagens permitidos
        $allowedTypes = ['image/jpg', 'image/jpeg', 'image/png'];

        $image = $request->file('cover');

        if($image) {
            // Se imagem é do tipo permitido
            if(in_array($image->getClientMimeType(), $allowedTypes)) {

                // Cria nome da imagem
                $filename = md5(time().rand(0,9999)).'.jpg';

                // Salva na pasta media/avatars
                $destPath = public_path('/media/covers');

                // Manipulação de imagens
                $img = Image::make($image->path())
                    ->fit(850, 310)
                    ->save($destPath.'/'.$filename);

                // Pega usuário logado e troca avatar
                $user = User::find($this->loggedUser['id']);
                $user->cover = $filename;
                $user->save();

                // Retorna nova url da imagem
                $array['url'] = url('/media/covers/'.$filename);

            } else {
                $array['error'] = 'Arquivo não suportado!';
                return $array;
            }

        } else {
            $array['error'] = 'Arquivo não enviado!';
            return $array;
        }

        return $array;
    }

    public function read($id = false) {
        // GET api/user
        // GET api/user/123
        $array = ['error' => ''];
        // Manda as informações que eu mandar...
        if($id) {
            $info = User::find($id);
            if(!$info) {
                $array['error'] = 'Usuário inexistente!';
                return $array;
            }
        } else { // ...ou do proprio usuario
            $info = $this->loggedUser;
        }

        $info['avatar'] = url('media/avatars/'.$info['avatar']);
        $info['cover'] = url('media/covers/'.$info['cover']);

        $info['me'] = ($info['id'] == $this->loggedUser['id']) ? true : false;
        
        // Idade em anos do usuário
        $dateFrom = new \DateTime($info['birthdate']);
        $dateTo = new \DateTime('today');
        $info['age'] = $dateFrom->diff($dateTo)->y;

        // Pega qtde de seguidores e seguidos
        $info['followers'] = UserRelation::where('user_to', $info['id'])->count();
        $info['following'] = UserRelation::where('user_from', $info['id'])->count();

        $info['photoCount'] = Post::where('id_user', $info['id'])
        ->where('type', 'photo')
        ->count();

        $hasRelation = UserRelation::where('user_from', $this->loggedUser['id'])
        ->where('user_to', $info['id'])
        ->count();
        $info['isFollowing'] = ($hasRelation > 0) ? true : false;

        $array['data'] = $info;

        return $array;
    }

    public function follow($id) {
        // POST api/user/123/follow
        $array = ['error' => ''];

        if($id == $this->loggedUser['id']) {
            $array['error'] = 'Você não pode seguir a si mesmo.';
            return $array;
        }
        
        $userExists = User::find($id);
        if($userExists) {
            // Verifica se usuario logado tem relação com usuário a seguir
            $relation = UserRelation::where('user_from', $this->loggedUser['id'])
            ->where('user_to', $id)
            ->first();

            if($relation) { // Se tiver relação
                // Parar de seguir
                $relation->delete(); 
            } else {// Se não tiver
                // Seguir
                $newRelation = new UserRelation();
                $newRelation->user_from = $this->loggedUser['id'];
                $newRelation->user_to = $id;
                $newRelation->save();
            }

        } else {
            $array['error'] = 'Usuário inexistente!';
            return $array;
        }
            
        return $array;
    }

    public function followers($id) {
        // GET api/user/123/followers
        $array = ['error' => ''];

        $userExists = User::find($id);
        if($userExists) {

            $followers = UserRelation::where('user_to', $id)->get();
            $following = UserRelation::where('user_from', $id)->get();

            $array['followers'] = [];
            $array['following'] = [];

            foreach($followers as $item) {
                $user = User::find($item['user_from']);
                $array['followers'][] = [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'avatar' => url('media/avatars/'.$user['avatar'])
                ];
            }

            foreach($following as $item) {
                $user = User::find($item['user_from']);
                $array['following'][] = [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'avatar' => url('media/avatars/'.$user['avatar'])
                ];
            }

        } else {
            $array['error'] = 'Usuário inexistente!';
            return $array;
        }

        return $array;
    }
    
}
